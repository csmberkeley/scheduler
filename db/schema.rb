# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160203050505) do

  create_table "announcements", force: true do |t|
    t.text     "info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attendances", force: true do |t|
    t.integer  "enroll_id"
    t.integer  "status"
    t.string   "reason"
    t.integer  "week"
    t.integer  "senroll_id"
    t.integer  "jenroll_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ckeditor_assets", force: true do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type"

  create_table "comments", force: true do |t|
    t.integer  "offer_id"
    t.integer  "user_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "courses", force: true do |t|
    t.string   "course_name"
    t.string   "semester"
    t.integer  "year"
    t.string   "password"
    t.string   "description"
    t.string   "instructor"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "limit"
    t.string   "base_week"
  end

  create_table "enrolls", force: true do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.integer  "section_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jenrolls", force: true do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.integer  "section_id"
    t.integer  "senroll"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jenrolls_senrolls", id: false, force: true do |t|
    t.integer "jenroll_id", null: false
    t.integer "senroll_id", null: false
  end

  create_table "mentorjoins", force: true do |t|
    t.integer  "jenroll_id"
    t.integer  "senroll_id"
    t.string   "location"
    t.string   "time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "offers", force: true do |t|
    t.integer  "section_id"
    t.integer  "user_id"
    t.text     "body"
    t.integer  "enroll_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "replies", force: true do |t|
    t.integer  "offer_id"
    t.integer  "user_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "requests", force: true do |t|
    t.integer  "section_id"
    t.integer  "user_id"
    t.integer  "priority"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sections", force: true do |t|
    t.string   "name"
    t.time     "start"
    t.time     "end"
    t.time     "temp_start"
    t.time     "temp_end"
    t.string   "date"
    t.string   "temp_date"
    t.boolean  "empty"
    t.integer  "course_id"
    t.string   "location"
    t.string   "temp_location"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "limit"
    t.string   "password"
    t.boolean  "pass_enabled",  default: false
  end

  create_table "senrolls", force: true do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.integer  "section_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", force: true do |t|
    t.string   "setting_name"
    t.string   "setting_type"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "transactions", force: true do |t|
    t.integer  "user_id"
    t.integer  "enroll_id"
    t.string   "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "nickname"
    t.boolean  "admin"
    t.integer  "section_id"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.boolean  "mentor_verified"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "wants", force: true do |t|
    t.integer  "offer_id"
    t.integer  "section_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
