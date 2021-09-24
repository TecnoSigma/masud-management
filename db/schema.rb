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

ActiveRecord::Schema.define(version: 2021_09_24_002149) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "arsenals", force: :cascade do |t|
    t.string "number"
    t.string "kind"
    t.string "caliber"
    t.string "sinarm"
    t.string "situation"
    t.integer "quantity", default: 0
    t.date "registration_validity"
    t.boolean "linked_at_post", default: false
    t.bigint "employee_id"
    t.bigint "status_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_arsenals_on_employee_id"
    t.index ["status_id"], name: "index_arsenals_on_status_id"
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.bigint "state_id"
    t.index ["state_id"], name: "index_cities_on_state_id"
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
    t.string "company"
    t.string "cnpj"
    t.string "email"
    t.string "secondary_email"
    t.string "tertiary_email"
    t.string "telephone"
    t.string "password"
    t.bigint "status_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status_id"], name: "index_customers_on_status_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "name"
    t.string "codename"
    t.date "admission_date"
    t.date "resignation_date"
    t.string "cvn_number"
    t.date "cvn_validation_date"
    t.string "rg"
    t.string "cpf"
    t.string "email"
    t.string "password"
    t.bigint "team_id"
    t.bigint "status_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status_id"], name: "index_employees_on_status_id"
    t.index ["team_id"], name: "index_employees_on_team_id"
  end

  create_table "employees_profiles", id: false, force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.bigint "profile_id", null: false
    t.index ["employee_id"], name: "index_employees_profiles_on_employee_id"
    t.index ["profile_id"], name: "index_employees_profiles_on_profile_id"
  end

  create_table "escorts", force: :cascade do |t|
    t.bigint "customer_id"
    t.bigint "status_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_escorts_on_customer_id"
    t.index ["status_id"], name: "index_escorts_on_status_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "name"
    t.string "kind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "states", force: :cascade do |t|
    t.string "name"
    t.integer "external_id"
  end

  create_table "statuses", force: :cascade do |t|
    t.string "name"
  end

  create_table "tackles", force: :cascade do |t|
    t.string "serial_number"
    t.bigint "employee_id"
    t.bigint "status_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_tackles_on_employee_id"
    t.index ["status_id"], name: "index_tackles_on_status_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "name"
    t.string "license_plate"
    t.string "color"
    t.bigint "status_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status_id"], name: "index_vehicles_on_status_id"
  end

end
