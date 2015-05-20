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

ActiveRecord::Schema.define(version: 20150513085405) do

  create_table "diymenus", force: :cascade do |t|
    t.integer  "public_account_id"
    t.integer  "parent_id"
    t.string   "name"
    t.string   "key"
    t.string   "url"
    t.boolean  "is_show"
    t.integer  "sort"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "diymenus", ["key"], name: "index_diymenus_on_key"
  add_index "diymenus", ["parent_id"], name: "index_diymenus_on_parent_id"
  add_index "diymenus", ["public_account_id"], name: "index_diymenus_on_public_account_id"

  create_table "organizations", force: :cascade do |t|
    t.string   "name"
    t.string   "contract"
    t.string   "logo_url"
    t.integer  "capacity",                     default: 0
    t.integer  "level",                        default: 0
    t.integer  "period",                       default: 0
    t.integer  "users_count",                  default: 0
    t.integer  "org_id"
    t.string   "initial_id"
    t.string   "weixin_secret_key"
    t.string   "weixin_token"
    t.string   "app_id"
    t.string   "encoding_aes_key",  limit: 43
    t.string   "qy_secret_key"
    t.string   "qy_token"
    t.string   "corp_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "organizations", ["initial_id"], name: "index_organizations_on_initial_id"
  add_index "organizations", ["name"], name: "index_organizations_on_name", unique: true

  create_table "user_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
  end

  add_index "user_hierarchies", ["ancestor_id", "descendant_id", "generations"], name: "user_anc_desc_idx", unique: true
  add_index "user_hierarchies", ["descendant_id"], name: "user_desc_idx"

  create_table "users", force: :cascade do |t|
    t.boolean  "subscribe",       default: false
    t.string   "openid"
    t.string   "nickname"
    t.integer  "sex",             default: 0
    t.string   "language"
    t.string   "city"
    t.string   "province"
    t.string   "country"
    t.string   "headimgurl"
    t.integer  "subscribe_time"
    t.string   "unionid"
    t.string   "name"
    t.string   "password_digest"
    t.string   "remember_token"
    t.string   "wechat"
    t.string   "email"
    t.string   "phone"
    t.boolean  "admin",           default: false
    t.integer  "role",            default: 0
    t.string   "qrcode_url"
    t.integer  "parent_id"
    t.integer  "organization_id"
    t.integer  "meeket_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "users", ["openid"], name: "index_users_on_openid", unique: true
  add_index "users", ["organization_id"], name: "index_users_on_organization_id"
  add_index "users", ["parent_id"], name: "index_users_on_parent_id"
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"
  add_index "users", ["unionid"], name: "index_users_on_unionid"

end
