# adapted from Jekyll docs
module Jekyll

  class CollectionPage < Page
    def initialize(site, base, dir, collectionKey, collectionList, collectionHtml = 'collection_index.html', collectionPrefixKey = 'collection_title_prefix', collectionPrefix = 'Collection: ')
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), collectionHtml)
      self.data['collectionKey'] = collectionKey
      self.data['collectionList'] = collectionList

      collection_title_prefix = site.config[collectionPrefixKey] || collectionPrefix
      self.data['title'] = "#{collection_title_prefix}#{collectionKey}"
    end
  end

  class CollectionPageGenerator < Generator
    safe true

    def initialize(*args)
      @collectionLayoutKey = 'collection_index'
      @collectionLayoutHtml = 'collection_index.html'
      @collectionDirKey = 'collections_dir'
      @collectionDir = 'collections'
      @collectionKey = nil
      @collectionPrefix = 'Collection: '
      @collectionPrefixKey = 'collection_title_prefix'
    end

    def generate(site)
      unless @collectionKey.nil?
        collection = site.post_attr_hash("#{@collectionKey}")
        collection.each_key do |item|
          site.pages << CollectionPage.new(site, site.source, File.join(@collectionDir, item), item, collection, @collectionLayoutHtml, @collectionPrefixKey, @collectionPrefix)
        end
      end
    end
  end

  class CategoryPageGenerator < CollectionPageGenerator
    safe true
    def initialize(*args)
      # make sure we use the superclass's attributes
      super(args)
      # and override what we need
      @collectionDirKey = 'categories_dir'
      @collectionDir = 'categories'
      @collectionKey = 'categories'
      @collectionPrefix = 'Category: '
      @collectionPrefixKey = 'categories_title_prefix'
    end
  end

  class TagPageGenerator < CollectionPageGenerator
    safe true
    def initialize(*args)
      # make sure we use the superclass's attributes
      super(args)
      # and override what we need
      @collectionDirKey = 'tags_dir'
      @collectionDir = 'tags'
      @collectionKey = 'tags'
      @collectionPrefix = 'Tag: '
      @collectionPrefixKey = 'tags_title_prefix'
    end
  end
end
