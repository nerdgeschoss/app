# frozen_string_literal: true

# == Schema Information
#
# Table name: job_applications
#
#  id                             :uuid             not null, primary key
#  available_from                 :date
#  craft_interview_booked_at      :datetime
#  craft_interview_scheduling_url :string
#  email                          :citext           not null
#  first_name                     :string           not null
#  github_handle                  :string
#  interview_booked_at            :datetime
#  interview_scheduling_url       :string
#  job_role                       :enum             not null
#  last_name                      :string           not null
#  level                          :enum             not null
#  motivation                     :text             not null
#  offered_level                  :enum
#  status                         :enum             default("review"), not null
#  token                          :string           not null
#  website_url                    :string
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  user_id                        :uuid
#
class JobApplication < ApplicationRecord
  include Yael::Publisher
  include Hiring

  belongs_to :user, optional: true

  has_many_attached :attachments

  has_secure_token :token

  enum :status, [:review, :interview, :craft_interview, :job_offer, :hired, :rejected].index_with(&:to_s)
  enum :job_role, [:developer, :designer, :product_manager].index_with(&:to_s), prefix: true
  enum :level, [:junior, :mid, :senior, :principal].index_with(&:to_s), prefix: true
  enum :offered_level, [:junior, :mid, :senior, :principal].index_with(&:to_s), prefix: true

  scope :with_filter, ->(filter) {
    case filter.to_s
    when "rejected" then rejected
    when "joined" then hired
    else where.not(status: [:hired, :rejected])
    end
  }

  validates :first_name, :last_name, :email, :motivation, presence: true
  validates :attachments, presence: true, on: :create

  def events
    Yael::Event.where(stream: Yael::Event.stream_for(self)).order(:created_at, :id)
  end

  # i18n-tasks-use t('job_application.job_role.designer') t('job_application.job_role.developer') t('job_application.job_role.product_manager')
  # i18n-tasks-use t('job_application.level.junior') t('job_application.level.mid') t('job_application.level.principal') t('job_application.level.senior')
  def position(level = self.level)
    I18n.t("job_application.position", level: I18n.t("job_application.level.#{level}"), role: I18n.t("job_application.job_role.#{job_role}"))
  end

  def full_name
    [first_name, last_name].filter_map(&:presence).join(" ")
  end

  def to_param
    token
  end
end
