# frozen_string_literal: true

SimpleForm.setup do |config|
  config.wrappers :default, tag: false do |b|
    b.use :input
  end
  config.default_wrapper = :default
  config.button_class = "button"
end

Rails.application.config.to_prepare do
  SimpleForm::FormBuilder.map_type :date, :time, :datetime, to: DateInput
end
