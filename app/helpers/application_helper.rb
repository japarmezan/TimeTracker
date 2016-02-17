require 'byebug'
# Application helper
module ApplicationHelper
  def print_errors(source)
    return "" if source.errors.empty?

    count = pluralize(source.errors.count, "problem")
    messages = source.errors.full_messages.map { |msg| content_tag(:li, msg) }.join

    html = <<-HTML
      <div id="error_explanation" class="well">
        <p class="text-danger">#{count}:</p>
        <ul class="text-danger">#{messages}</ul>
      </div>
    HTML
    html.html_safe
  end

  def print_notice(flash)
    return '' if flash.empty?

    if flash.notice
      notice = flash[:notice]

      html = <<-HTML
      <div class="alert alert-success alert-dismissible" role="alert">
        <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        #{notice}
      </div>
      HTML
    end

    if flash.alert
      alert = flash[:alert]

      html = <<-HTML
      <div class="alert alert-danger alert-dismissible" role="alert">
        <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        #{alert}
      </div>
      HTML
    end

    html.html_safe
  end
end
