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

ActiveRecord::Schema[8.1].define(version: 2025_12_04_040604) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "drivers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "license_number"
    t.string "name"
    t.integer "status"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["license_number"], name: "index_drivers_on_license_number"
    t.index ["user_id"], name: "index_drivers_on_user_id"
  end

  create_table "jwt_denylists", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "exp"
    t.datetime "expired_at"
    t.string "jti"
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_jwt_denylists_on_jti"
  end

  create_table "manifestos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "date"
    t.bigint "driver_id", null: false
    t.datetime "end_time"
    t.datetime "start_time"
    t.integer "status"
    t.datetime "updated_at", null: false
    t.bigint "vehicle_id", null: false
    t.index ["driver_id"], name: "index_manifestos_on_driver_id"
    t.index ["vehicle_id"], name: "index_manifestos_on_vehicle_id"
  end

  create_table "roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.bigint "resource_id"
    t.string "resource_type"
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "stops", force: :cascade do |t|
    t.string "address"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.bigint "manifesto_id", null: false
    t.integer "order"
    t.integer "status"
    t.integer "stop_type"
    t.datetime "updated_at", null: false
    t.index ["manifesto_id"], name: "index_stops_on_manifesto_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "jti"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "role_id"
    t.bigint "user_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  create_table "vehicles", force: :cascade do |t|
    t.float "capacity_tons"
    t.datetime "created_at", null: false
    t.bigint "driver_id", null: false
    t.string "license_plate"
    t.string "model"
    t.integer "status"
    t.datetime "updated_at", null: false
    t.index ["driver_id"], name: "index_vehicles_on_driver_id"
    t.index ["license_plate"], name: "index_vehicles_on_license_plate"
  end

  add_foreign_key "drivers", "users"
  add_foreign_key "manifestos", "drivers"
  add_foreign_key "manifestos", "vehicles"
  add_foreign_key "stops", "manifestos"
  add_foreign_key "vehicles", "drivers"
end
