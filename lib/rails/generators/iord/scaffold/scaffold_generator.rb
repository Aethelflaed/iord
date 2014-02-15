require 'rails/generators/resource_helpers'

module Iord
  module Generators
    class ScaffoldGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers

      def self.source_root
        @_iord_source_root ||= File.expand_path("../templates", __FILE__)
      end

      check_class_collision

      argument :attributes, type: :array, default: [], banner: 'field[:type][:index] field[:type][:index]'

      class_option :resource_route, type: :boolean

      hook_for :orm, as: :model, required: true

      def create_controller_files
        template 'controller.rb', File.join('app/controllers', controller_class_path, "#{controller_file_name}_controller.rb")
      end

      hook_for :test_framework, as: :scaffold
      hook_for :resource_route, in: :rails, required: :true
    end
  end
end

