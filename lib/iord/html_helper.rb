module Iord
  class HtmlHelper
    attr_accessor :view_context

    def initialize(view_context)
      @view_context = view_context
    end

    def fieldset(title, attrs, form, predicate = nil)
      html = %Q[<fieldset><legend>#{title}</legend>\n]
      attrs.each do |attr|
        if predicate.nil? or predicate.call(form, attr)
          html += view_context.field_form(form, attr)
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
      form.link_to_remove(view_context.t('iord.buttons.remove', model: attr_name), class: 'btn btn-default')
    end

    def link_to_add(form, attr_name, attr)
      form.link_to_add(view_context.t('iord.buttons.add', model: attr_name), attr, class: 'btn btn-default')
    end
  end
end

