# frozen_string_literal: true

module ResponseHelper
  [:get, :post, :patch, :delete].each do |method|
    define_method(method) do |action, **args|
      args[:headers] ||= {}
      args[:headers]["Content-Type"] ||= "application/json"
      args[:params] = args[:params].to_json if args[:params].present? && method != :get
      super(action, **args)
      @json = nil
    end
  end

  def json
    @json ||= (response.body.presence&.then { |body| JSON.parse(body, object_class: OpenStruct) })
  end

  def pjson
    msg = response.body.presence&.then { |body| JSON.pretty_generate(JSON.parse(body)) }
    puts(msg || "<nil>")
  end

  def pbody
    puts response.body
  end
end

RSpec.configure do |config|
  config.include ResponseHelper, type: :request
end
