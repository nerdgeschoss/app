# == Schema Information
#
# Table name: leaves
#
#  id           :uuid             not null, primary key
#  leave_during :daterange        not null
#  title        :string           not null
#  type         :string           default("paid"), not null
#  status       :string           default("pending_approval"), not null
#  days         :date             default("{}"), not null, is an Array
#  user_id      :uuid             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Leave < ApplicationRecord
  self.inheritance_column = nil

  belongs_to :user

  scope :reverse_chronologic, -> { order("UPPER(leaves.leave_during) DESC") }
  scope :during, ->(range) { where("leaves.leave_during && daterange(?, ?)", range.min, range.max) }

  enum type: [:paid, :sick].index_with(&:to_s)
  enum status: [:pending_approval, :approved].index_with(&:to_s)

  before_validation do
    start_on, end_on = days.minmax
    self.leave_during = start_on..end_on
  end

  def to_ics
    event = Icalendar::Event.new
    event.dtstart = Icalendar::Values::Date.new leave_during.min
    event.dtstart.ical_params = {"VALUE" => "DATE"}
    event.dtend = Icalendar::Values::Date.new leave_during.max
    event.dtend.ical_params = {"VALUE" => "DATE"}
    event.summary = "#{user.display_name}: #{title} #{paid? ? "\u{1F3D6}" : "\u{1F912}"}"
    event.url = Rails.application.routes.url_helpers.leaves_url(id: id)
    event
  end
end
