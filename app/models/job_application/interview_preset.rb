# frozen_string_literal: true

class JobApplication::InterviewPreset
  include UrlGenerating

  PRESETS = {
    first: "https://calendly.com/nerdgeschoss/first-interview",
    tech: "https://calendly.com/jensravens/tech-interview",
    design: "https://calendly.com/nerdgeschoss/design-interview"
  }.freeze

  class << self
    def all
      PRESETS.keys.map { new(it) }
    end

    def find(kind)
      new(kind.to_sym) if kind.present? && PRESETS.key?(kind.to_sym)
    end
  end

  attr_reader :kind

  def initialize(kind)
    @kind = kind
  end

  def scheduling_url
    PRESETS.fetch(kind)
  end

  def title
    I18n.t("job_application.interview_preset.#{kind}.title")
  end

  def message(job_application)
    I18n.t("job_application.interview_preset.#{kind}.message",
      name: job_application.first_name,
      url: job_application_url(job_application))
  end
end
