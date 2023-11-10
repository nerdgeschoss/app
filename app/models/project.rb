# == Schema Information
#
# Table name: projects
#
#  id           :uuid             not null, primary key
#  name         :string
#  client_name  :string
#  repositories :string           default([]), is an Array
#  harvest_ids  :bigint           default([]), is an Array
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Project < ApplicationRecord
  has_many :invoices, dependent: :destroy
  has_many :time_entries, dependent: :nullify
  has_many :tasks, dependent: :nullify
end
