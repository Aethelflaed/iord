module Iord
  class Resolver < ::ActionView::FileSystemResolver
    def initialize
      super File.expand_path(File.dirname(__FILE__) + '/../../app/views')
    end

    def find_templates(name, prefix, partial, details)
      super(name, '', partial, details)
    end
  end
end

