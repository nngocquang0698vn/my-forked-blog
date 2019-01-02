#!/usr/bin/env ruby

require 'json'
require 'kwalify'
require 'yaml'

def notify_search_engine(base_url, search_engine_url)
  raise 'Top-level URL not specified' unless base_url

  uri = URI(search_engine_url + URI.escape("#{base_url}/sitemap.xml"))
  response = Net::HTTP.get_response(uri)
  raise response unless response.is_a? Net::HTTPSuccess
  puts "Received code #{response.code} back from #{uri}"
end

def get_field_from_yaml(filename, field_name)
  h = YAML.load_file(filename)
  if h.key?(field_name) && h[field_name]
    h[field_name].split ' '
  else
    []
  end
end

def get_field_from_files(glob, field)
  arr = []
  Dir.glob(glob).each do |f|
    arr << get_field_from_yaml(f, field)
  end
  arr.flatten!.uniq!.sort!
end

def report_errors(all_errors)
  return false if all_errors.size.zero?

  puts 'Errors:'
  all_errors.each do |filename, errors|
    puts filename
    errors.each do |e|
      puts "- #{e}"
    end
  end
  true
end

namespace :test do
  desc 'Test links'
  task :links do
    # as Alpine doesn't have `nproc`, this is the next best thing
    num_cpus = `grep 'processor' /proc/cpuinfo  | wc -l`.to_i
    require 'html-proofer'
    options = {
      only_4xx: true,
      parallel: {
        in_processes: num_cpus
      },
      internal_domains: ['jvt.me', 'www.jvt.me'],
      url_ignore: [
        /pic\.twiter\.com/,
        /t\.co/
      ]
    }
    HTMLProofer.check_directory('./_site', options).run
  end

  desc 'Test GitHub/GitLab casing'
  task :git_casing do
    all_incorect_cases = {}
    Dir.glob('_site/**/*.html') do |f|
      contents = File.read f
       if contents.include?('Github')
         all_incorect_cases[f] ||= []
         all_incorect_cases[f] << 'Github should be capitalised'
       end

       if contents.include?('Gitlab')
         all_incorect_cases[f] ||= []
         all_incorect_cases[f] << 'Gitlab should be capitalised'
       end
    end
    fail if report_errors(all_incorect_cases)
  end
end

task test: ['test:links', 'test:git_casing']

desc 'Notify all search engines'
task :notify, [:fqdn] do |_, args|
  Rake::Task['notify:google'].invoke(args[:fqdn])
  Rake::Task['notify:bing'].invoke(args[:fqdn])
end

namespace :notify do
  require 'net/http'
  require 'uri'

  desc 'Notify Google of updated sitemap'
  task :google, [:fqdn] do |_, args|
    notify_search_engine(args[:fqdn], 'https://google.com/webmasters/tools/ping?sitemap=')
  end

  desc 'Notify Bing of updated sitemap'
  task :bing, [:fqdn] do |_, args|
    notify_search_engine(args[:fqdn], 'https://bing.com/webmaster/ping.aspx?siteMap=')
  end

  desc 'Notify Pushbullet of deployment'
  task :pushbullet do
    require 'pushbullet_ruby'
    client = PushbulletRuby::Client.new(ENV['PUSHBULLET_ACCESS_TOKEN'])
    out = client.push_link(
      receiver: :device,
      id: client.devices[0].id,
      params: {
        title: 'Deploy successful',
        body: 'jvt.me has deployed successfully',
        url: 'https://www.jvt.me'
      }
    )
    puts "Notification sent: #{out.id}"
  end
end

namespace :list do
  desc 'List all tags in the site'
  task :tags do
    arr = get_field_from_files('_posts/*.md', 'tags')
    puts "There are #{arr.length} tags: #{arr}"
  end

  desc 'List all categories in the site'
  task :categories do
    arr = get_field_from_files('_posts/*.md', 'categories')
    puts "There are #{arr.length} categories: #{arr}"
  end
end

namespace :validate do
  desc 'Validate posts are well-formed'
  task :posts do
    schema = YAML.load_file('.schema/post.yml')
    validator = Kwalify::Validator.new(schema)
    all_errors = {}
    Dir.glob('content/posts/*').each do |filename|
      document = YAML.load_file(filename)
      errors = validator.validate(document)
      all_errors[filename] = errors unless errors.length.zero?
    end
    fail if report_errors(all_errors)
  end
end

desc 'Determine if images have changed'
task :images_changed? do
  require 'git'
  g = Git.open('.')
  images_to_minify = g.diff('assets/img').map do |f|
    f.path
  end

  fail "Images are not all minified: #{images_to_minify}" unless images_to_minify.size.zero?
end

desc 'Create Bit.ly short URLs for a given article URL'
task :bitly_urls, [:url] do |_, args|
  raise 'Bit.ly personal access token not provided in ENV[BITLY_TOKEN]' if ENV.fetch('BITLY_TOKEN').to_s.length.zero?
  %w[slack.tn slack.c1 pulse twitter linkedin].each do |medium|
    body = {
      group_guid: 'Bb31fK0maG9',
      domain: 'u.jvt.me',
      long_url: args[:url] + "?utm_medium=#{medium}"
    }

    uri = URI.parse('https://api-ssl.bitly.com/v4/bitlinks')
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    req = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json'})
    req['Authorization'] = 'Bearer ' + ENV['BITLY_TOKEN']
    req.body = body.to_json
    res = https.request(req)
    if res.is_a?(Net::HTTPSuccess)
      res_body = JSON.parse(res.body)
      puts "#{medium}: #{res_body['link']}"
    else
      raise "Unsuccessful: Response #{res.code} #{res.message}: #{res.body}"
    end
  end
end

task validate: ['validate:posts']

task default: ['validate', 'test']
