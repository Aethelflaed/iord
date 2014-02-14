module Iord
  class Resolver < ::ActionView::FileSystemResolver
    def initialize
      super File.expand_path(File.dirname(__FILE__) + '/../../app/views')
    end

    def find_templates(name, prefix, partial, details)
      super(name, 'iord', partial, details)
    end
  end

  class GenericResolver < ::ActionView::FileSystemResolver
    def initialize(path, prefix)
      super File.expand_path("#{Rails.root}/app/views/#{path}")
      @prefix = prefix
    end

    def find_templates(name, prefix, partial, details)
      super(name, @prefix, partial, details)
    end
  end
end

