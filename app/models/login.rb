# frozen_string_literal: true

class Login
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :email, :string
  attribute :code, :string

  validates :email, presence: true
  validates :code, presence: true, on: :verify
  validate :code_matches, on: :verify

  def initialize(cookies:, **attrs)
    email, = cookies.encrypted[:auth_challenge]
    super(email: attrs[:email] || email, **attrs.except(:email))
    @cookies = cookies
  end

  def request_code
    correct_code = generate_code
    @cookies.encrypted[:auth_challenge] = {
      value: [email, correct_code],
      expires: 15.minutes.from_now,
      httponly: true
    }
    user = User.find_by(email:)
    UserMailer.login_code(user, correct_code).deliver_later if user
  end

  def verify
    return false unless valid?(:verify)
    @cookies.delete(:auth_challenge)
    true
  end

  def user
    User.find_by!(email:)
  end

  private

  def code_matches
    errors.add(:code, "is invalid") unless code == correct_code
  end

  def correct_code
    _, code = @cookies.encrypted[:auth_challenge]
    code
  end

  def generate_code
    dev_login? ? "999999" : SecureRandom.random_number(10**6).to_s.rjust(6, "0")
  end

  def dev_login?
    Rails.env.development? || Config.dev_login?
  end
end
