# frozen_string_literal: true

class BankHoliday
  class FeiertageApi
    class NetworkError < StandardError; end
    include Singleton

    def retrieve_bank_holidays(year:)
      response = request(year:)
      response.values.map { |e| e["datum"] }
    end

    private

    def request(year:)
      headers = {"Content-Type": "application/json"}
      response = HTTParty.get("https://feiertage-api.de/api/?jahr=#{year}&nur_land=BE", headers: headers) # Always gets the holidays for Berlin
      raise NetworkError, response["error"].humanize unless response.ok?

      response
    end
  end
end
