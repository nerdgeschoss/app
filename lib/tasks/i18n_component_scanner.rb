# frozen_string_literal: true

require "i18n/tasks/scanners/ruby_scanner"

# Resolves relative translation keys in phlex components the same way
# Components::Base#t does: app/components/user_card/user_card.rb has the
# scope "components.user_card" (the class name, not the file path).
class I18nComponentScanner < I18n::Tasks::Scanners::RubyScanner
  def absolute_key(key, path, **)
    return key unless key.start_with?(".")
    scope = File.dirname(File.expand_path(path)).sub(%r{\A.*/app/}, "").tr("/", ".")
    "#{scope}#{key}"
  end
end
