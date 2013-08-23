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

ActiveRecord::Schema.define(version: 20130823212239) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "branches", force: true do |t|
    t.string   "name",        null: false
    t.integer  "city_id"
    t.integer  "employee_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "branches", ["city_id"], name: "index_branches_on_city_id", using: :btree
  add_index "branches", ["employee_id"], name: "index_branches_on_employee_id", using: :btree
  add_index "branches", ["user_id"], name: "index_branches_on_user_id", using: :btree

  create_table "cities", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cities", ["user_id"], name: "index_cities_on_user_id", using: :btree

  create_table "clients", force: true do |t|
    t.string   "inn",        null: false
    t.string   "code",       null: false
    t.string   "name",       null: false
    t.integer  "city_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clients", ["city_id"], name: "index_clients_on_city_id", using: :btree
  add_index "clients", ["user_id"], name: "index_clients_on_user_id", using: :btree

  create_table "employees", force: true do |t|
    t.string   "firstname",   null: false
    t.string   "middlename",  null: false
    t.string   "lastname",    null: false
    t.string   "snils",       null: false
    t.integer  "level_id"
    t.integer  "position_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "employees", ["level_id"], name: "index_employees_on_level_id", using: :btree
  add_index "employees", ["position_id"], name: "index_employees_on_position_id", using: :btree
  add_index "employees", ["user_id"], name: "index_employees_on_user_id", using: :btree

  create_table "levels", force: true do |t|
    t.string   "name",       null: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "levels", ["user_id"], name: "index_levels_on_user_id", using: :btree

  create_table "positions", force: true do |t|
    t.string   "name",       null: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "positions", ["user_id"], name: "index_positions_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username",                            null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
