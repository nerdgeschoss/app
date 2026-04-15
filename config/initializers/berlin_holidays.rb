# frozen_string_literal: true

Rails.application.config.after_initialize do
  BerlinHolidays.warm_cache!
end
