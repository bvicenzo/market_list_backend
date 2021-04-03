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

ActiveRecord::Schema.define(version: 2021_04_03_013300) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "brands", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "raw_name", null: false
    t.string "picture_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["raw_name"], name: "index_brands_on_raw_name", unique: true
  end

  create_table "global_product_classifications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "code", null: false
    t.text "description", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_global_product_classifications_on_code", unique: true
  end

  create_table "mercosul_common_nomenclatures", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "code", null: false
    t.string "description", null: false
    t.string "full_description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_mercosul_common_nomenclatures_on_code", unique: true
  end

  create_table "specification_code_for_tax_substitutions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "code", null: false
    t.string "description", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_specification_code_for_tax_substitutions_on_code", unique: true
  end

end
