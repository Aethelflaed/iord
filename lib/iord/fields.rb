require 'active_support/concern'
require 'iord/output_helper'

module Iord
  module Fields
    extend ActiveSupport::Concern

    included do
      helper_method :field_name
      helper_method :field_form
      helper_method :field_value

      helper_method :iordh
    end

    def iordh
      @iordh ||= ::Iord::OutputHelper.new(view_context)
    end

    def field_name(attr, opts = {})
      return "id"           if attr == :_id
      # default, simply humanize name
      return attr           unless attr.is_a? Hash
      # else, Hash
      return attr[:object]  if attr.has_key? :object
      return attr[:array]   if attr.has_key? :array
      return attr[:value]   if attr.has_key? :value
      return attr[:link]    if attr.has_key? :link
      return field_name(attr.values[0], opts) if attr.values[0].is_a? Hash

      attr.keys[0]
    end

    def field_label(f, attr, opts = {})
      return f.label *attr[:label] if attr.has_key? :label
      f.label attr[:attr]
    end

    def field_form(f, attr, opts = {})
      if attr.is_a? Symbol
        return iordh.input(f.label(attr), f.text_field(attr), f.object.errors.full_messages_for(attr))
      elsif attr.is_a? Array
        label = f.label attr[1]
        field = f.public_send *attr
        errors = f.object.errors.full_messages_for(attr[1])
        return iordh.input(label, field, errors)
      elsif not attr.is_a? Hash
        raise ArgumentError, "Unrecognized attr: #{attr}"
      elsif attr.has_key? :fields
        return field_form_object(f, attr, opts)
      else
        field_form_hash(f, attr, opts)
      end
    end

    def field_form_hash(f, attr, opts = {})
      case attr[:field]
      when Array
        field = f.public_send    *attr[:field]
      when Hash
        _attrs = *attr[:field][:helper]
        field = self.public_send _attrs[0], f, attr, *_attrs[1..-1]
      else
        field = f.text_field attr[:field]
      end

      return field if attr.has_key? :hidden

      label = field_label(f, attr, opts)
      errors = f.object.errors.full_messages_for(attr[:attr])
      iordh.input(label, field, errors)
    end

    def field_form_object(f, attr, opts = {})
      multiple_items = attr[:attr].to_s.pluralize == attr[:attr].to_s

      attr_name = attr[:attr].to_s.singularize.humanize

      predicate = ->(form, attr) do
        !(multiple_items and
          form.object.new_record? and
          attr.is_a? Hash and
          attr.has_key? :not_new_record)
      end

      html = f.fields_for(attr[:attr]) do |ff|
        iordh.fieldset(attr_name, attr[:fields], ff, predicate) do
          if multiple_items
            iordh.link_to_remove(ff, attr_name)
          end
        end
      end
      if multiple_items
        html += iordh.link_to_add(f, attr_name, attr[:attr])
      end
      html.nil? ? String.new : html.html_safe
    end
    
    def field_value(resource, attr, opts = {})
      # default value for nil
      return '' if resource.nil?

      return resource.public_send(attr).to_s if attr.is_a? Symbol and attr.to_s.end_with? '_id'
      return resource.public_send(attr) unless attr.is_a? Hash

      # complex value with Hash
      if attr.has_key? :array
        iordh.display_array(resource.public_send(attr[:array]), attr[:attr][:attrs])
      elsif attr.has_key? :object
        iordh.display(resource.public_send(attr[:object]), attr[:attrs])
      elsif attr.has_key? :value
        if resource.respond_to? attr[:value]
          attr[:format].call(resource.public_send(attr[:value]))
        else
          attr[:format].call(resource, attr[:value])
        end
      elsif attr.has_key? :image
        iordh.image_tag resource.public_send(*attr[:image]), attr[:params]
      elsif attr.has_key? :link
        iordh.link_to attr[:label], attr[:url], attr[:params]
      else
        field_value resource.public_send(attr.keys[0]), attr.values[0], opts
      end
    end
  end
end

