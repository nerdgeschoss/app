# frozen_string_literal: true

class CreateJobApplications < ActiveRecord::Migration[8.1]
  def change
    create_enum :job_application_status, ["review", "interview", "craft_interview", "job_offer", "hired", "rejected"]
    create_enum :job_role, ["developer", "designer", "product_manager"]
    create_enum :job_level, ["junior", "mid", "senior", "principal"]

    create_table :job_applications, id: :uuid do |t|
      t.string :token, null: false, index: {unique: true}
      t.enum :status, enum_type: :job_application_status, null: false, default: "review"
      t.enum :job_role, enum_type: :job_role, null: false
      t.enum :level, enum_type: :job_level, null: false
      t.enum :offered_level, enum_type: :job_level
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.citext :email, null: false, index: true
      t.string :github_handle
      t.string :website_url
      t.date :available_from
      t.text :motivation, null: false
      t.string :interview_scheduling_url
      t.datetime :interview_booked_at
      t.string :craft_interview_scheduling_url
      t.datetime :craft_interview_booked_at
      t.references :user, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
