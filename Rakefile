#!/usr/bin/env ruby

require 'json'
require 'kwalify'
require 'rspec/core/rake_task'
require 'yaml'
require_relative 'lib/checks'

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

def validate_json(schema, glob)
    schema = YAML.load_file(".schema/#{schema}.yml")
    validator = Kwalify::Validator.new(schema)
    all_errors = {}
    Dir.glob(glob).each do |filename|
      document = JSON.parse(File.read(filename))
      errors = validator.validate(document)
      all_errors[filename] = errors unless errors.length.zero?
    end
    fail if report_errors(all_errors)
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
        /t\.co/,
        /indieauth.com/,
        /aperture.p3k.io/,
        /matrix.org/
      ]
    }
    HTMLProofer.check_directory('./public', options).run
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

  RSpec::Core::RakeTask.new(:spec)

  namespace :permalinks do
    desc 'Verify RSS permalinks are not broken'
    task :rss do
      permalinks = YAML.load_file('permalinks.yml')
      seen = []
      not_seen = []

      require 'nokogiri'
      feed = Nokogiri::XML(File.read('public/feed.xml'))

      feed.xpath('//item').each do |e|
        link = e.at_xpath('link').content
        # we don't care about anything that's not a blog post
        next unless /^https:\/\/www.jvt.me\/posts\//.match? link

        if permalinks['posts'].include? link
          seen << link
        else
          not_seen << link
        end
      end

      # if we've added a new post
      raise 'Posts not tracked in permalinks.yml ' + not_seen.to_s unless not_seen.length.zero?
      # if we've removed an old post
      raise "Posts seen (#{seen.length}) different to posts in `permalinks.yml` (#{permalinks['posts'].length})" if seen.length != permalinks['posts'].length
    end

    desc 'Verify sitemap permalinks are not broken'
    task :sitemap do
      permalinks = YAML.load_file('permalinks.yml')
      seen = []
      not_seen = []

      require 'nokogiri'
      feed = Nokogiri::XML(File.read('public/sitemap.xml'))

      feed.css('url').each do |e|
        link = e.css('loc').text
        # we don't care about anything that's not a blog post
        next unless /^https:\/\/www.jvt.me\/posts\/[0-9]{4}\//.match? link

        if permalinks['posts'].include? link
          seen << link
        else
          not_seen << link
        end
      end

      # if we've added a new post
      raise 'Posts not tracked in permalinks.yml ' + not_seen.to_s unless not_seen.length.zero?
      # if we've removed an old post
      raise "Posts seen (#{seen.length}) different to posts in `permalinks.yml` (#{permalinks['posts'].length})" if seen.length != permalinks['posts'].length
    end
  end

  desc 'Verify permalinks are not broken'
  task permalinks: ['permalinks:rss', 'permalinks:sitemap']


  desc 'Ensure that theme is pointing to origin/fork not a branch'
  task :theme_branch do
    Dir.chdir('themes/tale-hugo') do
      commit = `git rev-parse HEAD`.chomp
      contains = `git branch fork --contains #{commit}`
      raise "branch `fork` does not contain commit #{commit}" if contains.length.zero?
    end
  end
end

task test: ['test:spec', 'test:permalinks', 'test:links', 'test:git_casing', 'test:theme_branch']

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
  desc 'Validate bookmarks are well-formed'
  task :bookmarks do
    validate_json('bookmark', 'content/bookmarks/*')
  end

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

  desc 'Validate events are well-formed'
  task :events do
    schema = YAML.load_file('.schema/event.yml')
    validator = Kwalify::Validator.new(schema)
    all_errors = {}
    Dir.glob('content/events/*/[0-9]*').each do |filename|
      document = YAML.load_file(filename)
      errors = validator.validate(document)
      all_errors[filename] = errors unless errors.length.zero?
    end
    fail if report_errors(all_errors)
  end

  desc 'Validate likes are well-formed'
  task :likes do
    validate_json('note', 'content/notes/*')
  end

  desc 'Validate notes are well-formed'
  task :notes do
    validate_json('note', 'content/notes/*')
  end

  desc 'Validate replies are well-formed'
  task :replies do
    validate_json('reply', 'content/reply/*')
  end

  desc 'Validate reposts are well-formed'
  task :reposts do
    validate_json('repost', 'content/reposts/*')
  end

  desc 'Validate RSVPs are well-formed'
  task :rsvps do
    validate_json('rsvp', 'content/rsvps/*')
  end
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

desc 'New Branch + Post'
task :new, [:title] do |_, args|
  date_str = Date.today.iso8601
  date = Date.parse date_str
  puts `git checkout -b article/#{args[:title]}`
  puts `hugo new posts/#{date_str}-#{args[:title]}.md`
  new_url = "https://www.jvt.me/posts/#{date.year}/#{date.strftime('%m')}/#{date.strftime('%d')}/#{args[:title]}/"
  contents = YAML.load_file 'permalinks.yml'
  contents['posts'].unshift new_url

  File.open('permalinks.yml', 'w') do |f|
    f.write contents.to_yaml
  end
end

task validate: ['validate:bookmarks', 'validate:events', 'validate:likes', 'validate:notes', 'validate:posts', 'validate:replies', 'validate:reposts', 'validate:rsvps']

task default: ['validate', 'test']
