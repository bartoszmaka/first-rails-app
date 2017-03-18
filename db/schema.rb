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

ActiveRecord::Schema.define(version: 20170318162931) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "archivements", force: :cascade do |t|
    t.string   "name",                          null: false
    t.text     "description"
    t.integer  "users_count",       default: 0
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["name"], name: "index_archivements_on_name", using: :btree
  end

  create_table "article_tags", force: :cascade do |t|
    t.integer "article_id"
    t.integer "tag_id"
    t.index ["article_id"], name: "index_article_tags_on_article_id", using: :btree
    t.index ["tag_id"], name: "index_article_tags_on_tag_id", using: :btree
  end

  create_table "articles", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "user_id"
    t.integer  "comments_count", default: 0
    t.integer  "score",          default: 0
  end

  create_table "comments", force: :cascade do |t|
    t.text     "content"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "article_id"
    t.integer  "user_id"
    t.integer  "score",      default: 0
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.integer  "articles_count", default: 0
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "user_archivements", force: :cascade do |t|
    t.integer "user_id"
    t.integer "archivement_id"
    t.index ["archivement_id"], name: "index_user_archivements_on_archivement_id", using: :btree
    t.index ["user_id"], name: "index_user_archivements_on_user_id", using: :btree
  end

  create_table "user_roles", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "role_id", null: false
    t.index ["user_id", "role_id"], name: "index_user_roles_on_user_id_and_role_id", unique: true, using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "articles_count",         default: 0
    t.integer  "comments_count",         default: 0
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "votes", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "votable_type"
    t.integer  "votable_id"
    t.boolean  "positive",     default: false, null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["user_id"], name: "index_votes_on_user_id", using: :btree
    t.index ["votable_type", "votable_id"], name: "index_votes_on_votable_type_and_votable_id", using: :btree
  end

  add_foreign_key "articles", "users"
  add_foreign_key "comments", "articles"
  add_foreign_key "comments", "users"
end
