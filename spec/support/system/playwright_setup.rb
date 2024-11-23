# frozen_string_literal: true

# Then, we need to register our driver to be able to use it later
# with #driven_by method.
Capybara.register_driver(:custom_playwright) do |app|
  Capybara::Playwright::Driver.new(app,
    browser_type: :chromium,
    headless: !!Config.ci?)
end

Capybara.default_driver = Capybara.javascript_driver = :custom_playwright
Capybara.enable_aria_label = true

Capybara::Screenshot.screenshot_format = "webp"
Capybara::Screenshot.capybara_screenshot_options[:full_page] = true
Capybara::Screenshot.blur_active_element = true
Capybara::Screenshot.hide_caret = true
Capybara::Screenshot::Diff.enabled = false
