# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_10_09_025205) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "custom_rsvps", force: :cascade do |t|
    t.json "answers"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_custom_rsvps_on_user_id"
  end

  create_table "emails", id: :serial, force: :cascade do |t|
    t.string "subject"
    t.string "message"
    t.string "mailing_list"
    t.string "status"
    t.string "sent_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_applications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "status", default: "undecided"
    t.boolean "flag", default: false
    t.string "name"
    t.string "phone"
    t.string "age"
    t.string "university"
    t.string "major"
    t.string "grad_year"
    t.boolean "food_restrictions"
    t.text "food_restrictions_info"
    t.string "resume_file_name"
    t.string "resume_content_type"
    t.integer "resume_file_size"
    t.datetime "resume_updated_at"
    t.string "t_shirt_size"
    t.boolean "waiver_liability_agreement"
    t.string "education_lvl"
    t.boolean "mlh_agreement"
    t.string "gender"
    t.string "pronoun"
    t.json "custom_fields"
    t.boolean "mlh_communications"
  end

  create_table "event_attendances", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "event_id"
    t.integer "user_id"
    t.boolean "checked_in"
  end

  create_table "events", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "location"
    t.string "created_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "host"
    t.integer "max_seats"
    t.boolean "rsvpable"
  end

  create_table "feature_flags", force: :cascade do |t|
    t.string "name"
    t.boolean "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "display_name"
    t.string "description"
  end

  create_table "hardware_checkout_logs", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "hardware_item_id"
    t.string "action"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "message"
    t.index ["hardware_item_id"], name: "index_hardware_checkout_logs_on_hardware_item_id"
    t.index ["user_id"], name: "index_hardware_checkout_logs_on_user_id"
  end

  create_table "hardware_checkouts", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "hardware_item_id"
    t.index ["hardware_item_id"], name: "index_hardware_checkouts_on_hardware_item_id"
    t.index ["user_id"], name: "index_hardware_checkouts_on_user_id"
  end

  create_table "hardware_items", id: :serial, force: :cascade do |t|
    t.string "uid"
    t.string "name"
    t.string "link"
    t.string "category"
    t.integer "count"
    t.boolean "available"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "location"
  end

  create_table "judgements", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "score", default: -1
    t.integer "user_id"
    t.integer "project_id"
    t.json "custom_scores", default: "{}"
    t.string "tag"
  end

  create_table "judging_assignments", force: :cascade do |t|
    t.integer "user_id"
    t.integer "project_id"
    t.string "tag"
    t.index ["user_id", "project_id", "tag"], name: "index_judging_assignments_on_user_id_and_project_id_and_tag", unique: true
  end

  create_table "majors", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mentorship_notifications", force: :cascade do |t|
    t.bigint "user_id"
    t.json "tech", default: [], array: true
    t.boolean "all"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_mentorship_notifications_on_user_id"
  end

  create_table "mentorship_requests", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "mentor_id"
    t.string "title"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "urgency"
    t.string "description"
    t.string "tech", default: [], array: true
    t.string "screenshot_file_name"
    t.string "screenshot_content_type"
    t.bigint "screenshot_file_size"
    t.datetime "screenshot_updated_at"
  end

  create_table "prizes", force: :cascade do |t|
    t.string "award"
    t.string "description"
    t.string "title"
    t.string "sponsor"
    t.integer "priority"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "project_selectable", default: true
  end

  create_table "projects", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "projectimage_file_name"
    t.string "projectimage_content_type"
    t.integer "projectimage_file_size"
    t.datetime "projectimage_updated_at"
    t.string "inspiration"
    t.string "does_what"
    t.string "built_how"
    t.string "challenges"
    t.string "accomplishments"
    t.string "learned"
    t.string "next"
    t.string "built_with"
    t.boolean "power"
    t.integer "table_id"
    t.string "youtube_link"
    t.json "tech", default: [], array: true
    t.json "prizes", default: [], array: true
    t.json "prizes_won", default: [], array: true
  end

  create_table "universities", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_type", default: "attendee"
    t.boolean "rsvp", default: false
    t.boolean "check_in", default: false
    t.integer "project_id"
    t.string "slack_id"
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.json "tokens"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.boolean "non_transactional_email_consent", default: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "custom_rsvps", "users"
  add_foreign_key "hardware_checkout_logs", "hardware_items"
  add_foreign_key "hardware_checkout_logs", "users"
  add_foreign_key "hardware_checkouts", "hardware_items"
  add_foreign_key "hardware_checkouts", "users"
  add_foreign_key "mentorship_notifications", "users"
end
