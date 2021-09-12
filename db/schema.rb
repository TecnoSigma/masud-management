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

ActiveRecord::Schema.define(version: 2021_09_12_002110) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "arsenals", force: :cascade do |t|
    t.bigint "employee_id"
    t.bigint "status_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["employee_id"], name: "index_arsenals_on_employee_id"
    t.index ["status_id"], name: "index_arsenals_on_status_id"
  end

  create_table "clothings", force: :cascade do |t|
    t.bigint "employee_id"
    t.bigint "status_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["employee_id"], name: "index_clothings_on_employee_id"
    t.index ["status_id"], name: "index_clothings_on_status_id"
  end

  create_table "customers", force: :cascade do |t|
    t.bigint "status_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["status_id"], name: "index_customers_on_status_id"
  end

  create_table "employees", force: :cascade do |t|
    t.bigint "status_id"
    t.string "kind"
    t.bigint "team_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["status_id"], name: "index_employees_on_status_id"
    t.index ["team_id"], name: "index_employees_on_team_id"
  end

  create_table "escorts", force: :cascade do |t|
    t.bigint "customer_id"
    t.bigint "status_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["customer_id"], name: "index_escorts_on_customer_id"
    t.index ["status_id"], name: "index_escorts_on_status_id"
  end

  create_table "statuses", force: :cascade do |t|
    t.string "name"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "vehicles", force: :cascade do |t|
    t.bigint "status_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["status_id"], name: "index_vehicles_on_status_id"
  end

end
