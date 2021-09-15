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

ActiveRecord::Schema.define(version: 2021_09_12_002110) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "arsenals", force: :cascade do |t|
    t.bigint "employee_id"
    t.bigint "status_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_arsenals_on_employee_id"
    t.index ["status_id"], name: "index_arsenals_on_status_id"
  end

  create_table "clothings", force: :cascade do |t|
    t.bigint "employee_id"
    t.string "kind"
    t.bigint "status_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_clothings_on_employee_id"
    t.index ["status_id"], name: "index_clothings_on_status_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "email"
    t.string "password"
    t.bigint "status_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status_id"], name: "index_customers_on_status_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "email"
    t.string "password"
    t.string "kind"
    t.bigint "team_id"
    t.bigint "status_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status_id"], name: "index_employees_on_status_id"
    t.index ["team_id"], name: "index_employees_on_team_id"
  end

  create_table "escorts", force: :cascade do |t|
    t.bigint "customer_id"
    t.bigint "status_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_escorts_on_customer_id"
    t.index ["status_id"], name: "index_escorts_on_status_id"
  end

  create_table "statuses", force: :cascade do |t|
    t.string "name"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vehicles", force: :cascade do |t|
    t.bigint "status_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status_id"], name: "index_vehicles_on_status_id"
  end

end
