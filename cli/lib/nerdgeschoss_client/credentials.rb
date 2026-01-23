# frozen_string_literal: true

module NerdgeschossClient
  class Credentials
    def save!(email, auth_token)
      n = Netrc.read
      n[netrc_domain] = email, auth_token
      n.save
    end

    def auth_token
      n = Netrc.read
      n[netrc_domain]&.password
    end

    def delete!
      n = Netrc.read
      n.delete(netrc_domain)
      n.save
    end

    private

    def netrc_domain
      NerdgeschossClient::BASE_URL.host
    end
  end
end
