# frozen_string_literal: true

class JobApplication::Comment
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :body, :string

  attr_accessor :job_application, :author

  validates :body, presence: true

  def save
    return false unless valid?

    job_application.publish(:commented, job_application_id: job_application.id, author_id: author.id, body:)
    true
  end
end
