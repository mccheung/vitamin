module ErrorHelper
  def error_messages!(resource)
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join

    html = <<-HTML
    <div class="ui warning message">
      <ul class="list">#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end
end
