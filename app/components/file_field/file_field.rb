# frozen_string_literal: true

class Components::FileField < Components::Base
  prop :name, String
  prop :id, String
  prop :multiple, _Boolean, default: false
  prop :options, Hash, default: -> { {} }

  def view_template
    input(type: "file", name: @name, id: @id, multiple: @multiple, class: "file-field",
      data: {direct_upload_url: rails_direct_uploads_path}, **@options)
  end
end
