module Iord
  class OutputHelper
    attr_accessor :v

    def initialize(view_context)
      @v = view_context
    end

    def display(object, attrs)
      html  = "<dl>"
      attrs.each do |attr|
        html += "<dt>#{v.field_name(attr).to_s.humanize}</dt>"
        html += "<dd>#{v.field_value(object, attr)}</dd>"
      end
      html += "</dl>"
      html.html_safe
    end

    def display_array(array, attrs)
      html  = "<ul>"
      array.each do |element|
        html += "<li>#{display(element, attrs)}</li>"
      end
      html += "</ul>"
      html.html_safe
    end

    def fieldset(title, attrs, form, predicate = nil)
      html = %Q[<fieldset><legend>#{title}</legend>\n]
      attrs.each do |attr|
        if predicate.nil? or predicate.call(form, attr)
          html += v.field_form(form, attr)
        end
      end
      html += yield.to_s if block_given?
      html += "\n</fieldset>\n"
      html.html_safe
    end

    def input(label, input, errors)
      %Q[<div class="input">#{label}#{input}<div class="error">#{errors.join('<br />')}</div></div>\n].html_safe
    end

    def submit(form)
      %Q[<div class="actions">#{form.button nil, class: 'btn btn-default'}</div>]
    end

    def link_to_remove(form, attr_name)
      form.link_to_remove(v.t('iord.buttons.remove', model: attr_name), class: 'btn btn-default')
    end

    def link_to_add(form, attr_name, attr)
      form.link_to_add(v.t('iord.buttons.add', model: attr_name), attr, class: 'btn btn-default')
    end

    def link_to_create()
      v.link_to(v.t('iord.buttons.create'), v.new_resource_url,
                           class: 'btn btn-default')
    end

    def link_to_collection()
      v.link_to(v.t('iord.buttons.back'), v.collection_url,
                           class: 'btn btn-default')
    end

    def link_to_show(object = nil)
      v.link_to(v.t('iord.buttons.show'), v.resource_url(object),
                           class: 'btn btn-default')
    end

    def link_to_edit(object = nil)
      v.link_to(v.t('iord.buttons.edit'), v.edit_resource_url(object),
                           class: 'btn btn-default')
    end

    def link_to_destroy(object = nil)
      v.link_to(v.t('iord.buttons.destroy'), v.resource_url(object),
                           data: {method: 'delete', confirm: v.t('iord.alert.destroy')},
                           class: 'btn btn-default')
    end

    def link_to(label, url, hash)
      v.link_to(label, url, hash)
    end

    def image(url, hash)
      v.image_tag(url, hash)
    end
  end
end

