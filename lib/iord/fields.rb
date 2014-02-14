require 'active_support/concern'

module Iord
  module Fields
    extend ActiveSupport::Concern

    included do
      helper_method :field_name
      helper_method :field_form
      helper_method :field_value

      helper_method :fields_default_link_hash
      helper_method :fields_default_image_hash
    end

    def field_name(attr)
      return "id"           if attr == :_id
      # default, simply humanize name
      return attr           unless attr.is_a? Hash
      # else, Hash
      return attr[:object]  if attr.has_key? :object
      return attr[:array]   if attr.has_key? :array
      return attr[:value]   if attr.has_key? :value
      return attr[:link]    if attr.has_key? :link
      return field_name attr.values[0]  if attr.values[0].is_a? Hash

      attr.keys[0]
    end

    def field_label(f, attr)
      return f.label *attr[:label] if attr.has_key? :label
      f.label attr[:attr]
    end

    def field_form(f, attr)
      if attr.is_a? Symbol
        return %Q[<div class="input">#{f.label(attr)}#{f.text_field(attr)}</div>].html_safe
      elsif attr.is_a? Array
        field = f.public_send *attr
        label = f.label attr[1]
        return %Q[<div class="input">#{label}#{field}</div>].html_safe
      elsif not attr.is_a? Hash
        raise ArgumentError, "Unrecognized attr: #{attr}"
      elsif attr.has_key? :fields
        return field_form_object(f, attr)
      end

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

      label = field_label f, attr
      %Q[<div class="input">#{label}#{field}</div>].html_safe
    end

    def field_form_object(f, attr)
      html = String.new
      relation = f.object.class.relations[attr[:attr].to_s][:relation]
      multiple_items = (
        relation == Mongoid::Relations::Referenced::Many ||
        relation == Mongoid::Relations::Embedded::Many)

      html << f.fields_for(attr[:attr]) do |ff|
        content = "<fieldset><legend>#{attr[:attr].to_s.singularize.humanize}</legend>"
        attr[:fields].each do |attr|
          unless ff.object.new_record? and
            attr.is_a? Hash and
            attr.has_key? :not_new_record
            content << "  " + field_form(ff, attr)
          end
        end
        if multiple_items
          content << "  "
          content << ff.link_to_remove("Remove this #{attr[:attr].to_s.singularize.humanize}", class: 'btn btn-default')
        end
        content << "</fieldset>"
        content.html_safe
      end
      if multiple_items
        html << f.link_to_add("Add a #{attr[:attr].to_s.singularize.humanize}", attr[:attr], class: 'btn btn-default')
      end
      html << "<br>"
      html.html_safe
    end
    
    def field_value(resource, attr, opts = {})
      # default value for nil
      return '' if resource.nil?

      return resource.public_send(attr).to_s if attr.is_a? Symbol and attr.to_s.end_with? '_id'
      return resource.public_send(attr) unless attr.is_a? Hash

      # complex value with Hash
      if attr.has_key? :array
        field_value_array resource.public_send(attr[:array]), attr, opts
      elsif attr.has_key? :object
        field_value_object resource.public_send(attr[:object]), attr, opts
      elsif attr.has_key? :value
        if resource.respond_to? attr[:value]
          attr[:format].call(resource.public_send(attr[:value]))
        else
          attr[:format].call(resource, attr[:value])
        end
      elsif attr.has_key? :image
        field_value_image resource, resource.public_send(*attr[:image]), attr[:params], opts
      elsif attr.has_key? :link
        field_value_link resource, attr[:url], attr[:label], attr[:params], opts
      else
        field_value resource.public_send(attr.keys[0]), attr.values[0], opts
      end
    end

    def field_value_link(object, url, label, hash, opts = {})
      if opts.has_key? :json
        return label
      end
      hash ||= fields_default_link_hash
      view_context.link_to label, url, hash
    end

    def field_value_image(object, url, hash, opts = {})
      if opts.has_key? :json
        return {image: url}
      end
      hash ||= fields_default_image_hash
      view_context.image_tag url, hash
    end

    def field_value_object(object, attr, opts = {})
      json = {}
      dl_class = attr[:object_class].to_s
      html = %Q[<dl class="#{dl_class}">]
      attr[:attrs].each do |at|
        if opts.has_key? :json
          json[field_name(at)] = field_value(object, at, opts)
        else
          html << "<dt>#{field_name(at).to_s.humanize}</dt><dd>#{field_value(object, at)}</dd>"
        end
      end
      html << "</dl>"
      if opts.has_key? :json
        return json
      end
      html.html_safe
    end

    def field_value_array(array, attr, opts = {})
      json = []
      ul_class = attr[:array_class].to_s
      html = "<ul class=\"#{ul_class}\">"
      array.each do |e|
        if opts.has_key? :json
          json << field_value_object(e, attr[:attr], opts)
        else
          html << "<li>#{field_value_object e, attr[:attr]}</li>"
        end
      end
      html << "</ul>"
      if opts.has_key? :json
        return json
      end
      html.html_safe
    end

    def fields_default_link_hash
      {:class => 'btn btn-default'}
    end

    def fields_default_image_hash
      {}
    end
  end
end

