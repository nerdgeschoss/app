# frozen_string_literal: true

module LoginHelper
  def login(user)
    user = users(user) if user.is_a?(Symbol)
    set_encrypted_cookie("auth", user.id)
  end

  def set_encrypted_cookie(name, content)
    visit "/" if current_path.nil?
    jar = create_cookie_jar
    jar.encrypted[name] = content
    cypher = jar[name]
    page.driver.with_playwright_page do |page|
      page.context.add_cookies([
        {url: current_host, name:, value: Rack::Utils.escape(cypher)}
      ])
    end
  end

  def read_encrypted_cookie(name)
    encrypted_value = page.driver.cookies[name]&.value
    return unless encrypted_value
    encrypted_value = Rack::Utils.unescape(encrypted_value)
    jar = create_cookie_jar
    jar[name] = encrypted_value
    jar.encrypted[name]
  end

  def create_cookie_jar
    ActionDispatch::Request.new(Rails.application.env_config.deep_dup.merge("REQUEST_METHOD" => "GET")).cookie_jar
  end
end

RSpec.configure do |config|
  config.include LoginHelper, type: :system
  config.before(:each, type: :system) do |example|
    Current.reset
  end
end
