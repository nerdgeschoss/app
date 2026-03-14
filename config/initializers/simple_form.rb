# frozen_string_literal: true

SimpleForm.setup do |config|
  config.wrappers :default, tag: false do |b|
    b.use :input
  end
  config.default_wrapper = :default
  config.button_class = "button"
end
