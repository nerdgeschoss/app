# frozen_string_literal: true

if defined?(Rails::Console)
  require "irb"
  # patches this issue https://github.com/basecamp/mission_control-jobs/issues/42
  # and has a proposed fixed here https://github.com/basecamp/mission_control-jobs/pull/59
  # but it's not merged yet so we need to monkey patch it
end
