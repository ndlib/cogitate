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

ActiveRecord::Schema.define(version: 20150813181332) do

  create_table "cogitate_models_identifier_tickets", force: :cascade do |t|
    t.string   "encoded_id", limit: 255, null: false
    t.string   "ticket",     limit: 255, null: false
    t.datetime "expires_at",             null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "cogitate_models_identifier_tickets", ["encoded_id"], name: "index_cogitate_models_identifier_tickets_on_encoded_id", using: :btree
  add_index "cogitate_models_identifier_tickets", ["ticket", "expires_at"], name: "idx_cogitate_models_identifier_ticket_expiry", using: :btree
  add_index "cogitate_models_identifier_tickets", ["ticket"], name: "index_cogitate_models_identifier_tickets_on_ticket", unique: true, using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "identifying_value", limit: 255
    t.string   "name",              limit: 255,   null: false
    t.text     "description",       limit: 65535
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "groups", ["identifying_value"], name: "index_groups_on_identifying_value", unique: true, using: :btree
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
