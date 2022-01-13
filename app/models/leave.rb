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
  include RangeAccessing
  self.inheritance_column = nil

  belongs_to :user

  scope :chronologic, -> { order("UPPER(leaves.leave_during) ASC") }
  scope :reverse_chronologic, -> { order("UPPER(leaves.leave_during) DESC") }
  scope :during, ->(range) { where("leaves.leave_during && daterange(?, ?)", range.min, range.max) }
  scope :future, -> { where("UPPER(leaves.leave_during) > NOW()") }

  enum type: [:paid, :sick].index_with(&:to_s)
  enum status: [:pending_approval, :approved].index_with(&:to_s)

  range_accessor_methods :leave

  before_validation do
    start_on, end_on = days.minmax
    self.leave_during = start_on..end_on
  end

  def emoji
    paid? ? "\u{1F3D6}" : "\u{1F912}"
  end

  def to_ics
    event = Icalendar::Event.new
    event.dtstart = Icalendar::Values::Date.new leave_during.min
    event.dtstart.ical_params = {"VALUE" => "DATE"}
    event.dtend = Icalendar::Values::Date.new leave_during.max
    event.dtend.ical_params = {"VALUE" => "DATE"}
    event.summary = "#{user.display_name}: #{title} #{emoji}"
    event.url = Rails.application.routes.url_helpers.leaves_url(id: id)
    event
  end
end
