module ApplicationHelper

  def error_css(resource, field, css_class='error')
    resource.errors[field].present? ? " #{css_class}" : ''
  end

  def error_message_for_field(resource, field)
    if resource.errors[field].present?
      errors = resource.errors[field].join(', ')
      %Q(<span class="help-inline">#{errors}</span>).html_safe
    else
      ''
    end
  end

end
