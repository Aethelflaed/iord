require 'iord/output_helper'

module Iord
  class JsonOutput < ::Iord::OutputHelper
    def display(object, attrs)
      Hash[attrs.collect {|attr| [v.field_name(attr), v.field_value(object, attr)]}]
    end

    def display_array(array, attrs)
      array.collect {|element| display(element, attrs) }
    end

    def link_to(label, url, hsh)
      {url: url, label: label}
    end

    def image(url, hsh)
      {image: url}
    end
  end
end

