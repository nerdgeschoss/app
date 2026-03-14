# frozen_string_literal: true

class Login
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :email, :string
  attribute :code, :string

  validates :email, presence: true

  def request_code(cookies)
    generate_code
    cookies.encrypted[:auth_challenge] = {
      value: [email, code],
      expires: 15.minutes.from_now,
      httponly: true
    }
    user = User.find_by(email:)
    UserMailer.login_code(user, code).deliver_later if user
  end

  def self.from_cookie(cookies)
    email, code = cookies.encrypted[:auth_challenge]
    return nil unless email.present?
    new(email:, code:)
  end

  def verify(submitted_code, cookies)
    if code == submitted_code
      cookies.delete(:auth_challenge)
      true
    else
      errors.add(:code, "is invalid")
      false
    end
  end

  def user
    User.find_by!(email:)
  end

  private

  def generate_code
    self.code = dev_login? ? "999999" : SecureRandom.random_number(10**6).to_s.rjust(6, "0")
  end

  def dev_login?
    Rails.env.development? || Config.dev_login?
  end
end
