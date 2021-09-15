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

ActiveRecord::Schema.define(version: 2020_07_26_021811) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "agency"
    t.string "number"
    t.bigint "seller_id"
    t.bigint "bank_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bank_id"], name: "index_accounts_on_bank_id"
    t.index ["seller_id"], name: "index_accounts_on_seller_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "angels", force: :cascade do |t|
    t.string "name"
    t.string "cpf"
    t.string "status", default: "ativado"
    t.bigint "subscriber_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subscriber_id"], name: "index_angels_on_subscriber_id"
  end

  create_table "angels_drivers", id: false, force: :cascade do |t|
    t.bigint "angel_id", null: false
    t.bigint "driver_id", null: false
    t.index ["angel_id"], name: "index_angels_drivers_on_angel_id"
    t.index ["driver_id"], name: "index_angels_drivers_on_driver_id"
  end

  create_table "banks", force: :cascade do |t|
    t.string "compe_register"
    t.string "name"
  end

  create_table "cameras", force: :cascade do |t|
    t.string "kind"
    t.string "serial_number"
    t.string "ip"
    t.string "user", default: "admin"
    t.string "password"
    t.string "status", default: "desativado"
    t.boolean "functional", default: false
    t.boolean "configured", default: false
    t.date "acquisition_date"
    t.bigint "kit_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kit_id"], name: "index_cameras_on_kit_id"
  end

  create_table "chips", force: :cascade do |t|
    t.string "kind"
    t.string "serial_number"
    t.string "status", default: "desativado"
    t.boolean "functional", default: false
    t.boolean "configured", default: false
    t.date "acquisition_date"
    t.bigint "kit_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kit_id"], name: "index_chips_on_kit_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.string "author"
    t.bigint "ticket_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ticket_id"], name: "index_comments_on_ticket_id"
  end

  create_table "delivery_cities", force: :cascade do |t|
    t.string "federative_unit"
    t.string "locality"
    t.string "initial_postal_code"
    t.string "final_postal_code"
    t.integer "express_time"
    t.integer "road_time"
    t.string "price"
    t.string "destiny_freight"
    t.string "distributor"
    t.string "redispatch"
    t.integer "risk_group"
  end

  create_table "delivery_tariffs", force: :cascade do |t|
    t.string "federative_unit"
    t.string "destiny"
    t.string "kind"
    t.float "kg_1"
    t.float "kg_2"
    t.float "kg_3"
    t.float "kg_4"
    t.float "kg_5"
    t.float "kg_6"
    t.float "kg_7"
    t.float "kg_8"
    t.float "kg_9"
    t.float "kg_10"
    t.float "kg_11"
    t.float "kg_12"
    t.float "kg_13"
    t.float "kg_14"
    t.float "kg_15"
    t.float "kg_16"
    t.float "kg_17"
    t.float "kg_18"
    t.float "kg_19"
    t.float "kg_20"
    t.float "kg_21"
    t.float "kg_22"
    t.float "kg_23"
    t.float "kg_24"
    t.float "kg_25"
    t.float "kg_26"
    t.float "kg_27"
    t.float "kg_28"
    t.float "kg_29"
    t.float "kg_30"
    t.float "additional_kg"
  end

  create_table "drivers", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "license"
    t.boolean "paid_activity", default: false
    t.datetime "expedition_date"
    t.datetime "expiration_date"
    t.string "status", default: "ativado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "drivers_vehicles", id: false, force: :cascade do |t|
    t.bigint "driver_id", null: false
    t.bigint "vehicle_id", null: false
    t.index ["driver_id"], name: "index_drivers_vehicles_on_driver_id"
    t.index ["vehicle_id"], name: "index_drivers_vehicles_on_vehicle_id"
  end

  create_table "kits", force: :cascade do |t|
    t.string "serial_number"
    t.bigint "subscriber_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subscriber_id"], name: "index_kits_on_subscriber_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "code"
    t.float "price"
    t.string "status", default: "pendente"
    t.datetime "approved_at"
    t.bigint "subscription_id"
    t.bigint "seller_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["seller_id"], name: "index_orders_on_seller_id"
    t.index ["subscription_id"], name: "index_orders_on_subscription_id"
  end

  create_table "plans", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.float "price", default: 0.0
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ratings", force: :cascade do |t|
    t.float "rate", default: 10.0
    t.string "comment"
    t.bigint "driver_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id"], name: "index_ratings_on_driver_id"
  end

  create_table "receipts", force: :cascade do |t|
    t.string "serial", default: "A-1"
    t.jsonb "credits"
    t.jsonb "debits"
    t.string "period"
    t.bigint "seller_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["seller_id"], name: "index_receipts_on_seller_id"
  end

  create_table "routers", force: :cascade do |t|
    t.string "operator"
    t.string "kind"
    t.string "serial_number"
    t.string "user"
    t.string "password"
    t.string "imei"
    t.string "status", default: "desativado"
    t.boolean "functional", default: false
    t.boolean "configured", default: false
    t.date "acquisition_date"
    t.bigint "kit_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kit_id"], name: "index_routers_on_kit_id"
  end

  create_table "sellers", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "core_register"
    t.datetime "expedition_date"
    t.datetime "expiration_date"
    t.string "password"
    t.string "document"
    t.string "cellphone"
    t.string "email"
    t.string "linkedin"
    t.string "address"
    t.string "number"
    t.string "complement"
    t.string "district"
    t.string "city"
    t.string "state"
    t.string "postal_code"
    t.string "status", default: "pendente"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscribers", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "responsible_cpf"
    t.string "responsible_name"
    t.string "document"
    t.string "kind"
    t.string "address"
    t.string "number"
    t.string "complement"
    t.string "district"
    t.string "city"
    t.string "state"
    t.string "postal_code"
    t.string "ip"
    t.string "email"
    t.string "telephone"
    t.string "cellphone"
    t.string "user"
    t.string "password"
    t.string "status"
    t.date "deleted_at"
    t.bigint "plan_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id"], name: "index_subscribers_on_plan_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string "code"
    t.string "status"
    t.integer "vehicles_amount", default: 0
    t.bigint "subscriber_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subscriber_id"], name: "index_subscriptions_on_subscriber_id"
  end

  create_table "tickets", force: :cascade do |t|
    t.string "department"
    t.string "responsible"
    t.string "subject"
    t.string "status"
    t.boolean "delayed", default: false
    t.boolean "finished", default: false
    t.boolean "recurrence", default: false
    t.bigint "subscriber_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subscriber_id"], name: "index_tickets_on_subscriber_id"
  end

  create_table "vehicle_brands", force: :cascade do |t|
    t.string "brand"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vehicle_models", force: :cascade do |t|
    t.string "kind"
    t.bigint "vehicle_brand_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["vehicle_brand_id"], name: "index_vehicle_models_on_vehicle_brand_id"
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "brand"
    t.string "kind"
    t.string "license_plate"
    t.string "status", default: "ativado"
    t.bigint "subscriber_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subscriber_id"], name: "index_vehicles_on_subscriber_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
