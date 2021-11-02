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

ActiveRecord::Schema.define(version: 2021_11_01_162717) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "arsenals", force: :cascade do |t|
    t.string "type"
    t.bigint "employee_id"
    t.bigint "status_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "number"
    t.string "kind"
    t.string "caliber"
    t.string "sinarm"
    t.string "situation"
    t.date "registration_validity"
    t.boolean "linked_at_post", default: false
    t.integer "quantity", default: 0
    t.index ["employee_id"], name: "index_arsenals_on_employee_id"
    t.index ["status_id"], name: "index_arsenals_on_status_id"
  end

  create_table "bullets", force: :cascade do |t|
    t.integer "quantity"
    t.string "caliber"
    t.bigint "employee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_bullets_on_employee_id"
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.bigint "state_id"
    t.index ["state_id"], name: "index_cities_on_state_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "company"
    t.string "cnpj"
    t.string "email"
    t.string "secondary_email"
    t.string "tertiary_email"
    t.string "telephone"
    t.string "password"
    t.datetime "deleted_at"
    t.bigint "status_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status_id"], name: "index_customers_on_status_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "name"
    t.string "type"
    t.string "codename"
    t.date "admission_date"
    t.date "resignation_date"
    t.string "cvn_number"
    t.date "cvn_validation_date"
    t.string "rg"
    t.string "cpf"
    t.string "email"
    t.string "password"
    t.datetime "deleted_at"
    t.boolean "in_mission", default: false
    t.datetime "last_mission"
    t.bigint "team_id"
    t.bigint "status_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status_id"], name: "index_employees_on_status_id"
    t.index ["team_id"], name: "index_employees_on_team_id"
  end

  create_table "item_movimentations", force: :cascade do |t|
    t.boolean "input", default: false
    t.boolean "output", default: false
    t.integer "quantity", default: 0
    t.bigint "arsenal_id"
    t.bigint "tackle_id"
    t.bigint "vehicle_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["arsenal_id"], name: "index_item_movimentations_on_arsenal_id"
    t.index ["tackle_id"], name: "index_item_movimentations_on_tackle_id"
    t.index ["vehicle_id"], name: "index_item_movimentations_on_vehicle_id"
  end

  create_table "mission_histories", force: :cascade do |t|
    t.string "team"
    t.text "agents", default: [], array: true
    t.text "items", default: [], array: true
    t.bigint "mission_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mission_id"], name: "index_mission_histories_on_mission_id"
  end

  create_table "missions", force: :cascade do |t|
    t.datetime "started_at"
    t.datetime "finished_at"
    t.bigint "team_id"
    t.bigint "escort_service_id"
    t.bigint "status_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["escort_service_id"], name: "index_missions_on_escort_service_id"
    t.index ["status_id"], name: "index_missions_on_status_id"
    t.index ["team_id"], name: "index_missions_on_team_id"
  end

  create_table "munition_stocks", force: :cascade do |t|
    t.string "caliber"
    t.integer "quantity", default: 0
    t.datetime "last_update"
  end

  create_table "orders", force: :cascade do |t|
    t.string "type"
    t.string "order_number"
    t.string "job_day"
    t.string "job_horary"
    t.string "source_address"
    t.string "source_number"
    t.string "source_complement"
    t.string "source_district"
    t.string "source_city"
    t.string "source_state"
    t.string "destiny_address"
    t.string "destiny_number"
    t.string "destiny_complement"
    t.string "destiny_district"
    t.string "destiny_city"
    t.string "destiny_state"
    t.string "observation"
    t.string "reason"
    t.datetime "deleted_at"
    t.bigint "customer_id"
    t.bigint "status_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_orders_on_customer_id"
    t.index ["status_id"], name: "index_orders_on_status_id"
  end

  create_table "service_tokens", force: :cascade do |t|
    t.string "token"
    t.bigint "customer_id"
    t.bigint "employee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_service_tokens_on_customer_id"
    t.index ["employee_id"], name: "index_service_tokens_on_employee_id"
  end

  create_table "states", force: :cascade do |t|
    t.string "name"
    t.integer "external_id"
  end

  create_table "statuses", force: :cascade do |t|
    t.string "name"
  end

  create_table "tackles", force: :cascade do |t|
    t.string "type"
    t.bigint "employee_id"
    t.bigint "status_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "serial_number"
    t.string "register_number"
    t.string "brand"
    t.date "fabrication_date"
    t.date "validation_date"
    t.date "bond_date"
    t.string "protection_level"
    t.string "situation"
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
    t.bigint "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status_id"], name: "index_vehicles_on_status_id"
    t.index ["team_id"], name: "index_vehicles_on_team_id"
  end

end
