# frozen_string_literal: true

class Components::StorypointList < Components::Base
  include ActiveSupport::NumberHelper

  prop :sprint, Sprint

  def view_template
    stack do
      @sprint.storypoints_per_department.each do |dept|
        stack(line: :mobile, justify: :"space-between") do
          text(type: :"body-regular") { dept[:team] }
          text(type: :"body-regular") { "#{number_to_rounded(dept[:points], precision: 1)} pts" }
          text(type: :"body-regular") { "#{dept[:working_days]} days" }
          text(type: :"body-regular") { "#{number_to_rounded(dept[:points_per_working_day], precision: 1)} pts/day" }
        end
      end
      stack(line: :mobile, justify: :"space-between") do
        text(type: :"body-regular") { "Total" }
        text(type: :"body-regular") { "#{number_to_rounded(total_points, precision: 1)} pts" }
        text(type: :"body-regular") { "" }
        text(type: :"body-regular") { "" }
      end
    end
  end

  private

  def total_points
    @sprint.storypoints_per_department.sum { _1[:points] }
  end
end
