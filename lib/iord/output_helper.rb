module Iord
  class OutputHelper
    attr_accessor :v

    def initialize(view_context)
      @v = view_context
    end

    def display(object, attrs)
      v.content_tag(:dl, nil, nil, false) do
        attrs.collect do |attr|
          v.content_tag(:dt, v.field_name(object, attr).to_s.humanize) +
            v.content_tag(:dd, v.field_value(object, attr))
        end.join.html_safe
      end
    end

    def display_array(array, attrs)
      v.content_tag(:ul, nil, nil, false) do
        array.collect do |el|
          v.content_tag(:li, display(el, attrs))
        end.join.html_safe
      end
    end

    def fieldset(title, attrs, form, predicate = nil)
      v.content_tag(:fieldset, nil, nil, false) do
        c = v.content_tag(:legend, title)
        c += attrs.collect do |attr|
          if predicate.nil? or predicate.call(form, attr)
            v.field_form(form, attr)
          end
        end.compact.join.html_safe
        c += yield.to_s.html_safe if block_given?
      end
    end

    def input(label, input, errors)
      v.content_tag(:div, {'class' => :input}, nil, false) do
        c = label.html_safe
        c += input.html_safe
        c += v.content_tag(:div, errors.join('<br />').html_safe, {'class' => :error}, false)
      end
    end

    def submit(form)
      v.content_tag(:div, form.button(nil, class: 'btn btn-default'), {'class' => :actions})
    end

    def link_to_remove(form, attr_name)
      form.link_to_remove(v.t('iord.buttons.remove', model: attr_name), class: 'btn btn-default')
    end

    def link_to_add(form, attr_name, attr)
      form.link_to_add(v.t('iord.buttons.add', model: attr_name), attr, class: 'btn btn-default')
    end

    def link_to_create()
      if v.new_resource_url?
        v.link_to(v.t('iord.buttons.create'),
                  v.new_resource_url,
                  class: 'btn btn-default')
      end
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
      if v.edit_resource_url?
        v.link_to(v.t('iord.buttons.edit'),
                  v.edit_resource_url(object),
                  class: 'btn btn-default')
      end
    end

    def link_to_destroy(object = nil)
      v.link_to(v.t('iord.buttons.destroy'), v.resource_url(object),
                           data: {method: 'delete', confirm: v.t('iord.alert.destroy')},
                           class: 'btn btn-default')
    end

    def link_to(label, url, hsh)
      v.link_to(label, url, hsh)
    end

    def image(url, hsh)
      hsh ||= {}
      v.image_tag(url, hsh)
    end
  end
end

