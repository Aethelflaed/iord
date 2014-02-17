require 'iord/output_helper'

module Iord
  class JsonOutput < ::Iord::OutputHelper
    def display(object, attrs)
      json = {}
      attrs.each do |attr|
        json[v.field_name(attr)] = v.field_value(object, attr)
      end
      return json
    end

    def display_array(array, attrs)
      json = []
      array.each do |element|
        json << display(element, attrs)
      end
      return json
    end

    def link_to(label, url, hash)
      {url: url, label: label}
    end

    def image(url, hash)
      {image: url}
    end
  end
end

