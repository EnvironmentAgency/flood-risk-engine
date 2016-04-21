module FloodRiskEngine
  module ApplicationHelper
    # This helper  adds a form-group DIV around form elements,
    # and takes the actual form fields as a content block.
    #
    # Some coupling with app/views/flood_risk_engine/enrollments/_validation_errors.html.erb which displays
    # the actual validation errors and links between error display and the
    # associated form-group defined here
    #
    # Example Usage :
    # <%= form_group_and_validation(@enrollment, :base) do %>
    #   <%= form.radio_button "blah", "new", checked: false, class: "radio" %>
    #   <%= form.radio_button "blah", "renew", checked: false, class: "radio" %>
    # <% end %>
    #
    def form_group_and_validation(form, attribute, &block)
      content = block_given? ? capture(&block) : ""

      options = { id: error_link_id(attribute),
                  role: "group",
                  'aria-labelledby': "groupLabel"
      }

      if form && form.errors[attribute].any?

        content = content_tag(:span, form.errors[attribute].first.to_s.html_safe,
                              class: "error-message") + content

        content_tag(:div, content, options.merge(class: "form-group error"))

      else
        content_tag(:div, content, options.merge(class: "form-group"))
      end
    end

    def error_link_id(attribute)
      # with nested attributes can get full path e.g applicant_contact.full_name
      # we only want the last field
      field = attribute.to_s.split(/\./).last
      "form_group_#{field}"
    end

    def set_page_title(title)
      return unless title.present?

      stripped_title = title.gsub(/’/, %('))

      if content_for? :page_title
        content_for :page_title, " | #{stripped_title}"
      else
        content_for :page_title, "GOV.UK | #{stripped_title}"
      end

      title
    end

    def submit_button_text(_enrollment)
      t("global.continue")
    end
  end
end
