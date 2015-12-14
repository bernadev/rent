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

ActiveRecord::Schema.define(version: 20151105145341) do

  create_table "configs", force: :cascade do |t|
    t.string   "key",        limit: 255
    t.string   "value",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "keywords", force: :cascade do |t|
    t.string   "word",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "rooms", force: :cascade do |t|
    t.string   "url",          limit: 255
    t.float    "time",         limit: 24
    t.float    "price",        limit: 24
    t.string   "status",       limit: 255
    t.string   "requirements", limit: 255
    t.string   "description",  limit: 255
    t.boolean  "discarded"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "rooms", ["url"], name: "index_rooms_on_url", unique: true, using: :btree

end
