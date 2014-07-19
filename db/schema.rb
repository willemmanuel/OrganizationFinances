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

ActiveRecord::Schema.define(version: 20151203230538) do

  create_table "attendances", force: true do |t|
    t.integer  "meeting_id"
    t.integer  "brother_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "chapter_id"
    t.integer  "semester_id"
  end

  add_index "attendances", ["semester_id"], name: "index_attendances_on_semester_id"

  create_table "brothers", force: true do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "email"
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "demerit"
    t.integer  "chapter_id"
    t.boolean  "active"
  end

  create_table "chapters", force: true do |t|
    t.string   "chapter"
    t.string   "national"
    t.string   "school"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "collections", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "chapter_id"
    t.integer  "semester_id"
  end

  add_index "collections", ["semester_id"], name: "index_collections_on_semester_id"

  create_table "committees", force: true do |t|
    t.string   "name"
    t.decimal  "budget"
    t.integer  "brother_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "chapter_id"
    t.integer  "semester_id"
  end

  add_index "committees", ["semester_id"], name: "index_committees_on_semester_id"

  create_table "debts", force: true do |t|
    t.string   "name"
    t.integer  "brother_id"
    t.decimal  "amount"
    t.boolean  "status"
    t.date     "due"
    t.date     "paid"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "chapter_id"
    t.integer  "collection_id"
    t.integer  "semester_id"
  end

  add_index "debts", ["semester_id"], name: "index_debts_on_semester_id"

  create_table "deposits", force: true do |t|
    t.date     "date"
    t.decimal  "amount"
    t.string   "name"
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "chapter_id"
    t.boolean  "donation"
    t.boolean  "posted"
    t.integer  "semester_id"
  end

  add_index "deposits", ["semester_id"], name: "index_deposits_on_semester_id"

  create_table "expenses", force: true do |t|
    t.date     "date"
    t.integer  "brother_id"
    t.integer  "committee_id"
    t.string   "item"
    t.boolean  "reimbursed"
    t.string   "notes"
    t.decimal  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "chapter_id"
    t.boolean  "posted"
    t.integer  "collection_id"
    t.integer  "semester_id"
  end

  add_index "expenses", ["semester_id"], name: "index_expenses_on_semester_id"

  create_table "meetings", force: true do |t|
    t.date     "date"
    t.integer  "attendance_id"
    t.string   "minutes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "chapter_id"
    t.integer  "semester_id"
  end

  add_index "meetings", ["semester_id"], name: "index_meetings_on_semester_id"

  create_table "semesters", force: true do |t|
    t.string   "name"
    t.integer  "semester_id"
    t.integer  "chapter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "current",     default: false
  end

  add_index "semesters", ["chapter_id"], name: "index_semesters_on_chapter_id"
  add_index "semesters", ["semester_id"], name: "index_semesters_on_semester_id"

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "approved",               default: false, null: false
    t.integer  "chapter_id"
    t.boolean  "chapter_manager"
    t.integer  "brother_id"
  end

  add_index "users", ["approved"], name: "index_users_on_approved"
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
