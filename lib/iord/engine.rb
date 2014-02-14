module Iord
  class Engine < Rails::Engine
    config.i18n.load_path += Dir[File.expand_path(File.dirname(__FILE__) + '/../../config/locales') + '/**/*.yml']
  end
end

