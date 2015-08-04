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

ActiveRecord::Schema.define(version: 20150804123029) do

  create_table "groups", id: false, force: :cascade do |t|
    t.string   "id",          limit: 255
    t.string   "name",        limit: 255,   null: false
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "groups", ["id"], name: "index_groups_on_id", unique: true, using: :btree
  add_index "groups", ["name"], name: "index_groups_on_name", unique: true, using: :btree

  create_table "repository_service_identifier_relationships", force: :cascade do |t|
    t.string   "left_strategy",           limit: 255, null: false
    t.string   "left_identifying_value",  limit: 255, null: false
    t.string   "right_strategy",          limit: 255, null: false
    t.string   "right_identifying_value", limit: 255, null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "repository_service_identifier_relationships", ["left_strategy", "left_identifying_value", "right_strategy", "right_identifying_value"], name: "idx_rs_identifier_relationships_both", unique: true, using: :btree
  add_index "repository_service_identifier_relationships", ["left_strategy", "left_identifying_value"], name: "idx_rs_identifier_relationships_left", using: :btree
  add_index "repository_service_identifier_relationships", ["right_strategy", "right_identifying_value"], name: "idx_rs_identifier_relationships_right", using: :btree

end
