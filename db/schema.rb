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

ActiveRecord::Schema.define(version: 2013_11_04_093757) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "averagebills", force: :cascade do |t|
    t.integer "year", null: false
    t.integer "month", null: false
    t.float "bill", null: false
    t.bigint "user_id"
    t.bigint "branch_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["branch_id"], name: "index_averagebills_on_branch_id"
    t.index ["user_id"], name: "index_averagebills_on_user_id"
  end

  create_table "branches", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "city_id"
    t.bigint "employee_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_branches_on_city_id"
    t.index ["employee_id"], name: "index_branches_on_employee_id"
    t.index ["user_id"], name: "index_branches_on_user_id"
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_cities_on_user_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "inn", null: false
    t.string "code", null: false
    t.string "name", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_clients_on_user_id"
  end

  create_table "debts", force: :cascade do |t|
    t.integer "year", null: false
    t.integer "month", null: false
    t.bigint "employee_id"
    t.bigint "client_id"
    t.bigint "order_id"
    t.float "debtsum", null: false
    t.integer "debttype", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_debts_on_client_id"
    t.index ["employee_id"], name: "index_debts_on_employee_id"
    t.index ["order_id"], name: "index_debts_on_order_id"
    t.index ["user_id"], name: "index_debts_on_user_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "firstname", null: false
    t.string "middlename", null: false
    t.string "lastname", null: false
    t.string "snils", null: false
    t.bigint "level_id"
    t.bigint "position_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "branch_id"
    t.date "birthdate"
    t.boolean "gender"
    t.text "about"
    t.string "phone"
    t.string "site"
    t.string "facebook"
    t.string "twitter"
    t.string "skype"
    t.string "vkontakte"
    t.string "avatar"
    t.bigint "account_id"
    t.index ["account_id"], name: "index_employees_on_account_id"
    t.index ["branch_id"], name: "index_employees_on_branch_id"
    t.index ["level_id"], name: "index_employees_on_level_id"
    t.index ["position_id"], name: "index_employees_on_position_id"
    t.index ["user_id"], name: "index_employees_on_user_id"
  end

  create_table "eventlogs", force: :cascade do |t|
    t.string "action"
    t.string "model"
    t.text "message"
    t.bigint "user_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_eventlogs_on_user_id"
  end

  create_table "factors", force: :cascade do |t|
    t.bigint "branch_id"
    t.bigint "user_id"
    t.integer "month"
    t.integer "year"
    t.float "prepay"
    t.integer "avaragebill"
    t.float "clients"
    t.float "weight"
    t.float "incomes"
    t.float "prolongcent"
    t.float "proplancor"
    t.float "planproc04from"
    t.float "planproc04to"
    t.float "planproc06from"
    t.float "planproc06to"
    t.float "planproc08from"
    t.float "planproc08to"
    t.float "planproc10from"
    t.float "planproc10to"
    t.float "planproc12from"
    t.float "planproc12to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["branch_id"], name: "index_factors_on_branch_id"
    t.index ["user_id"], name: "index_factors_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "code", null: false
    t.bigint "branch_id"
    t.bigint "employee_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["branch_id"], name: "index_groups_on_branch_id"
    t.index ["employee_id"], name: "index_groups_on_employee_id"
    t.index ["user_id"], name: "index_groups_on_user_id"
  end

  create_table "incomes", force: :cascade do |t|
    t.datetime "indate", null: false
    t.bigint "client_id"
    t.float "insum", null: false
    t.bigint "employee_id"
    t.boolean "cash"
    t.bigint "order_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_incomes_on_client_id"
    t.index ["employee_id"], name: "index_incomes_on_employee_id"
    t.index ["order_id"], name: "index_incomes_on_order_id"
    t.index ["user_id"], name: "index_incomes_on_user_id"
  end

  create_table "levels", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_levels_on_user_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "ordernum", null: false
    t.datetime "orderdate", null: false
    t.datetime "startdate", null: false
    t.datetime "finishdate", null: false
    t.integer "status", null: false
    t.float "ordersum", null: false
    t.integer "continue", null: false
    t.bigint "employee_id"
    t.bigint "client_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "city_id"
    t.bigint "order_id"
    t.index ["city_id"], name: "index_orders_on_city_id"
    t.index ["client_id"], name: "index_orders_on_client_id"
    t.index ["employee_id"], name: "index_orders_on_employee_id"
    t.index ["order_id"], name: "index_orders_on_order_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "plancents", force: :cascade do |t|
    t.integer "year"
    t.integer "month"
    t.bigint "branch_id"
    t.bigint "user_id"
    t.integer "fromprc"
    t.integer "toprc"
    t.float "mult"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["branch_id"], name: "index_plancents_on_branch_id"
    t.index ["user_id"], name: "index_plancents_on_user_id"
  end

  create_table "planfacts", force: :cascade do |t|
    t.date "report_date"
    t.integer "planfactable_id"
    t.string "planfactable_type"
    t.integer "clients_plan"
    t.integer "clients_fact"
    t.float "weight_plan"
    t.float "weight_fact"
    t.float "income_plan"
    t.float "income_fact"
    t.float "pro_percent"
    t.float "employee_ic"
    t.float "group_ic"
    t.float "branch_ic"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plans", force: :cascade do |t|
    t.integer "year", null: false
    t.integer "month", null: false
    t.integer "clients", null: false
    t.bigint "employee_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_plans_on_employee_id"
    t.index ["user_id"], name: "index_plans_on_user_id"
  end

  create_table "positions", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "show_experience_level"
    t.index ["user_id"], name: "index_positions_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "suspensions", force: :cascade do |t|
    t.bigint "employee_id"
    t.string "employed_type"
    t.bigint "employed_id"
    t.index ["employed_id", "employed_type", "employee_id"], name: "suspensions_index"
    t.index ["employed_type", "employed_id"], name: "index_suspensions_on_employed_type_and_employed_id"
    t.index ["employee_id"], name: "index_suspensions_on_employee_id"
  end

  create_table "uploads", force: :cascade do |t|
    t.string "upload_file_name"
    t.string "upload_content_type"
    t.integer "upload_file_size"
    t.datetime "upload_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.string "avatar"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "authentication_token"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

end
