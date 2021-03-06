require 'active_support/concern'
require 'iord/output_helper'

module Iord
  module Fields
    extend ActiveSupport::Concern

    included do
      helper_method :field_attribute
      helper_method :field_name
      helper_method :field_form
      helper_method :field_value

      helper_method :iordh
    end

    def iordh
      @iordh ||= OutputHelper.new(view_context)
    end

    # Use for sort_if_enabled which requires the attribute name
    def field_attribute(attr)
      return 'id'           if attr == :_id
      # default, simply return name
      return attr           unless attr.is_a? Hash
      # else, Hash
      return attr[:object]  if attr.has_key? :object
      return attr[:array]   if attr.has_key? :array
      return attr[:value]   if attr.has_key? :value
      return attr[:link]    if attr.has_key? :link

      attr.keys[0]
    end

    def field_name(resource, attr = nil)
      attr = resource if attr.nil?

      return 'id'           if attr == :_id
      # default, simply return name
      return attr           unless attr.is_a? Hash
      # else, Hash
      return attr[:as]      if attr.has_key? :as
      return attr[:object]  if attr.has_key? :object
      return attr[:array]   if attr.has_key? :array
      return attr[:value]   if attr.has_key? :value

      link = attr[:link]
      link = link.call(resource, attr) if link.respond_to? :call

      link || attr.keys[0]
    end

    def field_label(f, attr)
      return f.label *attr[:as] if attr.has_key? :as
      f.label attr[:attr]
    end

    def field_form(f, attr)
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
        return field_form_object(f, attr)
      else
        field_form_hash(f, attr)
      end
    end

    def field_form_hash(f, attr)
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

      label = field_label(f, attr)
      errors = f.object.errors.full_messages_for(attr[:attr])
      iordh.input(label, field, errors)
    end

    def field_form_object(f, attr)
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
    
    def field_value(resource, attr)
      # default value for nil
      return '' if resource.nil?

      if attr.is_a? Symbol and
        (attr.to_s.end_with? '_id' or
         attr == :id or
         attr == :_id)

        return resource.public_send(attr).to_s
      end
      return resource.public_send(attr) unless attr.is_a? Hash

      # complex value with Hash
      if attr.has_key? :array
        iordh.display_array(resource.public_send(attr[:array]), attr[:attrs])
      elsif attr.has_key? :object
        iordh.display(resource.public_send(attr[:object]), attr[:attrs])
      elsif attr.has_key? :value
        if resource.respond_to? attr[:value]
          attr[:format].call(resource.public_send(attr[:value]))
        else
          attr[:format].call(resource, attr[:value])
        end
      elsif attr.has_key? :image
        iordh.image resource.public_send(*attr[:image]), attr[:params]
      elsif attr.has_key? :link
        label, url = attr[:label], attr[:url]
        label = label.call(resource, attr) if label.respond_to? :call
        url = url.call(resource, attr) if url.respond_to? :call

        iordh.link_to label, url, attr[:params]
      else
        field_value(resource.public_send(attr.keys[0]), attr.values[0])
      end
    end
  end
end

