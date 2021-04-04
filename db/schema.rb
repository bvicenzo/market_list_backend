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

ActiveRecord::Schema.define(version: 2021_04_04_161251) do

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

  create_table "global_trade_item_numbers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "number", null: false
    t.string "type_packaging", null: false
    t.integer "quantity_packaging", null: false
    t.integer "ballast"
    t.integer "layer"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "product_id", null: false
    t.index ["number"], name: "index_global_trade_item_numbers_on_number", unique: true
    t.index ["product_id"], name: "index_global_trade_item_numbers_on_product_id"
  end

  create_table "mercosul_common_nomenclatures", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "code", null: false
    t.string "description", null: false
    t.string "full_description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_mercosul_common_nomenclatures_on_code", unique: true
  end

  create_table "products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "raw_name"
    t.string "thumbnail"
    t.decimal "width"
    t.decimal "height"
    t.decimal "length"
    t.decimal "net_weight"
    t.decimal "gross_weight"
    t.string "price"
    t.decimal "avg_price", precision: 10, scale: 2
    t.decimal "max_price", precision: 10, scale: 2
    t.decimal "min_price", precision: 10, scale: 2
    t.string "origin"
    t.string "barcode_image"
    t.uuid "brand_id"
    t.uuid "global_product_classification_id"
    t.uuid "mercosul_common_nomenclature_id"
    t.uuid "specification_code_for_tax_substitution_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["brand_id"], name: "index_products_on_brand_id"
    t.index ["global_product_classification_id"], name: "index_products_on_global_product_classification_id"
    t.index ["mercosul_common_nomenclature_id"], name: "index_products_on_mercosul_common_nomenclature_id"
    t.index ["raw_name"], name: "index_products_on_raw_name"
    t.index ["specification_code_for_tax_substitution_id"], name: "index_products_on_specification_code_for_tax_substitution_id"
  end

  create_table "specification_code_for_tax_substitutions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "code", null: false
    t.string "description", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_specification_code_for_tax_substitutions_on_code", unique: true
  end

  add_foreign_key "global_trade_item_numbers", "products", on_delete: :cascade
  add_foreign_key "products", "brands", on_delete: :cascade
  add_foreign_key "products", "global_product_classifications", on_delete: :cascade
  add_foreign_key "products", "mercosul_common_nomenclatures", on_delete: :cascade
  add_foreign_key "products", "specification_code_for_tax_substitutions", on_delete: :cascade
end
