# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_07_26_135402) do

  create_table "link_visits", force: :cascade do |t|
    t.integer "shortened_link_id"
    t.string "ip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["shortened_link_id"], name: "index_link_visits_on_shortened_link_id"
  end

  create_table "shortened_links", force: :cascade do |t|
    t.string "original_url"
    t.string "shortened_url"
    t.integer "transitions", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "visitors", force: :cascade do |t|
    t.integer "shortened_link_id"
    t.string "ip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["shortened_link_id"], name: "index_visitors_on_shortened_link_id"
  end

end
