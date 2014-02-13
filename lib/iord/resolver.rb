module Iord
  class Resolver < ::ActionView::FileSystemResolver
    def initialize
      super 'app/views'
    end

    def find_templates(name, prefix, partial, details)
      super(name, '', partial, details)
    end
  end
end

