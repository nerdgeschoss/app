# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_03_09_110848) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.uuid "blob_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: 6, null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "leaves", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.daterange "leave_during", null: false
    t.string "title", null: false
    t.string "type", default: "paid", null: false
    t.string "status", default: "pending_approval", null: false
    t.date "days", default: [], null: false, array: true
    t.uuid "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_leaves_on_user_id"
  end

  create_table "payslips", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.date "month", null: false
    t.uuid "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_payslips_on_user_id"
  end

  create_table "sprint_feedbacks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "sprint_id", null: false
    t.uuid "user_id", null: false
    t.integer "daily_nerd_count"
    t.decimal "tracked_hours"
    t.decimal "billable_hours"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "review_notes"
    t.datetime "daily_nerd_entry_dates", precision: 6, default: [], null: false, array: true
    t.integer "retro_rating"
    t.string "retro_text"
    t.index ["sprint_id", "user_id"], name: "index_sprint_feedbacks_on_sprint_id_and_user_id", unique: true
    t.index ["sprint_id"], name: "index_sprint_feedbacks_on_sprint_id"
    t.index ["user_id"], name: "index_sprint_feedbacks_on_user_id"
  end

  create_table "sprints", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.daterange "sprint_during", null: false
    t.integer "working_days", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "time_entries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "external_id"
    t.decimal "hours", null: false
    t.decimal "rounded_hours", null: false
    t.string "billable", null: false
    t.string "project_name", null: false
    t.string "client_name", null: false
    t.string "task", null: false
    t.decimal "billable_rate"
    t.decimal "cost_rate"
    t.string "notes"
    t.uuid "user_id", null: false
    t.uuid "sprint_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["external_id"], name: "index_time_entries_on_external_id", unique: true
    t.index ["sprint_id"], name: "index_time_entries_on_sprint_id"
    t.index ["user_id"], name: "index_time_entries_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "roles", default: [], null: false, array: true
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: 6
    t.datetime "remember_created_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name"
    t.string "last_name"
    t.string "slack_id"
    t.date "born_on"
    t.date "hired_on"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "leaves", "users"
  add_foreign_key "payslips", "users"
  add_foreign_key "sprint_feedbacks", "sprints"
  add_foreign_key "sprint_feedbacks", "users"
  add_foreign_key "time_entries", "sprints"
  add_foreign_key "time_entries", "users"
end
