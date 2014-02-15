require 'rails/generators/resource_helpers'

module Iord
  module Generators
    class ControllerGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers

      def self.source_root
        @_iord_source_root ||= File.expand_path("../templates", __FILE__)
      end

      check_class_collision suffix: 'Controller'

      class_option :resource_route, type: :boolean

      def create_controller_files
        template 'controller.rb', File.join('app/controllers', controller_class_path, "#{controller_file_name}_controller.rb")
      end

      hook_for :test_framework, as: :scaffold
      hook_for :resource_route, in: :rails
    end
  end
end

