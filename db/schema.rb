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

ActiveRecord::Schema.define(version: 20130910174613) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "averagebills", force: true do |t|
    t.integer  "year",       null: false
    t.integer  "month",      null: false
    t.float    "bill",       null: false
    t.integer  "user_id"
    t.integer  "branch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "averagebills", ["branch_id"], name: "index_averagebills_on_branch_id", using: :btree
  add_index "averagebills", ["user_id"], name: "index_averagebills_on_user_id", using: :btree

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
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clients", ["user_id"], name: "index_clients_on_user_id", using: :btree

  create_table "debts", force: true do |t|
    t.integer  "year",        null: false
    t.integer  "month",       null: false
    t.integer  "employee_id"
    t.integer  "client_id"
    t.integer  "order_id"
    t.float    "debtsum",     null: false
    t.integer  "debttype",    null: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "debts", ["client_id"], name: "index_debts_on_client_id", using: :btree
  add_index "debts", ["employee_id"], name: "index_debts_on_employee_id", using: :btree
  add_index "debts", ["order_id"], name: "index_debts_on_order_id", using: :btree
  add_index "debts", ["user_id"], name: "index_debts_on_user_id", using: :btree

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
    t.integer  "branch_id"
  end

  add_index "employees", ["branch_id"], name: "index_employees_on_branch_id", using: :btree
  add_index "employees", ["level_id"], name: "index_employees_on_level_id", using: :btree
  add_index "employees", ["position_id"], name: "index_employees_on_position_id", using: :btree
  add_index "employees", ["user_id"], name: "index_employees_on_user_id", using: :btree

  create_table "eventlogs", force: true do |t|
    t.string   "action"
    t.string   "model"
    t.text     "message"
    t.integer  "user_id"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "eventlogs", ["user_id"], name: "index_eventlogs_on_user_id", using: :btree

  create_table "groups", force: true do |t|
    t.string   "code",        null: false
    t.integer  "branch_id"
    t.integer  "employee_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["branch_id"], name: "index_groups_on_branch_id", using: :btree
  add_index "groups", ["employee_id"], name: "index_groups_on_employee_id", using: :btree
  add_index "groups", ["user_id"], name: "index_groups_on_user_id", using: :btree

  create_table "incomes", force: true do |t|
    t.datetime "indate",      null: false
    t.integer  "client_id"
    t.float    "insum",       null: false
    t.integer  "employee_id"
    t.boolean  "cash"
    t.integer  "order_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "incomes", ["client_id"], name: "index_incomes_on_client_id", using: :btree
  add_index "incomes", ["employee_id"], name: "index_incomes_on_employee_id", using: :btree
  add_index "incomes", ["order_id"], name: "index_incomes_on_order_id", using: :btree
  add_index "incomes", ["user_id"], name: "index_incomes_on_user_id", using: :btree

  create_table "levels", force: true do |t|
    t.string   "name",       null: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "levels", ["user_id"], name: "index_levels_on_user_id", using: :btree

  create_table "orders", force: true do |t|
    t.string   "ordernum",    null: false
    t.datetime "orderdate",   null: false
    t.datetime "startdate",   null: false
    t.datetime "finishdate",  null: false
    t.integer  "status",      null: false
    t.float    "ordersum",    null: false
    t.integer  "continue",    null: false
    t.integer  "employee_id"
    t.integer  "client_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "city_id"
  end

  add_index "orders", ["city_id"], name: "index_orders_on_city_id", using: :btree
  add_index "orders", ["client_id"], name: "index_orders_on_client_id", using: :btree
  add_index "orders", ["employee_id"], name: "index_orders_on_employee_id", using: :btree
  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "plans", force: true do |t|
    t.integer  "year",        null: false
    t.integer  "month",       null: false
    t.integer  "clients",     null: false
    t.integer  "employee_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "plans", ["employee_id"], name: "index_plans_on_employee_id", using: :btree
  add_index "plans", ["user_id"], name: "index_plans_on_user_id", using: :btree

  create_table "positions", force: true do |t|
    t.string   "name",                  null: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "show_experience_level"
  end

  add_index "positions", ["user_id"], name: "index_positions_on_user_id", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "suspensions", force: true do |t|
    t.integer "employee_id"
    t.integer "employed_id"
    t.string  "employed_type"
  end

  add_index "suspensions", ["employed_id", "employed_type", "employee_id"], name: "suspensions_index", using: :btree

  create_table "uploads", force: true do |t|
    t.string   "upload_file_name"
    t.string   "upload_content_type"
    t.integer  "upload_file_size"
    t.datetime "upload_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "userifications", force: true do |t|
    t.integer "user_id"
    t.integer "userable_id"
    t.string  "userable_type"
  end

  add_index "userifications", ["userable_id", "userable_type", "user_id"], name: "userification_index", using: :btree

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
    t.string   "avatar"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

end
