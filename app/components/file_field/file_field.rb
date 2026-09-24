# frozen_string_literal: true

class Components::FileField < Components::Base
  prop :name, String
  prop :id, String
  prop :multiple, _Boolean, default: false
  prop :description, _Nilable(String)
  prop :options, Hash, default: -> { {} }

  def view_template
    div(class: "file-field", data: {controller: "file-field"}) do
      div(class: "file-field__drop-zone") do
        # Covers the drop zone invisibly, so clicking and dropping both use the native input.
        input(type: "file", name: @name, id: @id, multiple: @multiple, class: "file-field__input",
          data: {direct_upload_url: rails_direct_uploads_path, file_field_target: "input", action: "file-field#list"}, **@options)
        text(type: "caption-primary-regular", color: "label-heading-primary") do
          span(class: "file-field__choose") { t(".choose") }
          plain " #{t(".drop")}"
        end
        text(type: "caption-secondary-regular", color: "label-caption-secondary") { @description } if @description
      end
      div(class: "file-field__files", data: {file_field_target: "files"})
      template(data: {file_field_target: "template"}) do
        div(class: "file-field__file") do
          span(class: "file-field__name")
          button(type: "button", class: "file-field__remove", aria_label: t(".remove"), data: {action: "file-field#remove"})
        end
      end
    end
  end
end
