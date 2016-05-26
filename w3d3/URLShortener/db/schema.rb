# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160525233256) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "shortened_urls", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "long_url",   null: false
    t.integer  "user_id",    null: false
    t.string   "short_url"
  end

  add_index "shortened_urls", ["user_id"], name: "index_shortened_urls_on_user_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tag_id",        null: false
    t.integer  "tagged_url_id", null: false
  end

  add_index "taggings", ["tag_id", "tagged_url_id"], name: "index_taggings_on_tag_id_and_tagged_url_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "topic",      null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                      null: false
    t.boolean  "premium",    default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree

  create_table "visits", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "visitor_id",     null: false
    t.integer  "visited_url_id", null: false
  end

  add_index "visits", ["visitor_id", "visited_url_id"], name: "index_visits_on_visitor_id_and_visited_url_id", using: :btree

end
