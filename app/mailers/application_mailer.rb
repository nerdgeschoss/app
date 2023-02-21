# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "info@nerdgeschoss.de"
  layout "mailer"
end
