# frozen_string_literal: true

module ComponentHelper
  def render_component(component)
    controller = ActionView::TestCase::TestController.new
    controller.request = ActionDispatch::TestRequest.create
    html = controller.view_context.render(component, &nil)
    Nokogiri::HTML5.fragment(html)
  end
end

RSpec.configure do |config|
  config.include ComponentHelper, type: :component
end
