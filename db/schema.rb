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

ActiveRecord::Schema.define(version: 20180820060427) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "questionnaires", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "sex"
    t.date "birthday"
    t.integer "birthplace"
    t.integer "education"
    t.integer "job"
    t.integer "question1"
    t.integer "question2"
    t.integer "question3"
    t.integer "question4"
    t.integer "question5"
    t.integer "question6"
    t.integer "question7"
    t.integer "question8"
    t.integer "question9"
    t.integer "question10"
    t.integer "question11"
    t.integer "question12"
    t.integer "question13"
    t.integer "question14"
    t.integer "question15"
    t.integer "question16"
    t.integer "question17"
    t.integer "question18"
    t.integer "question19"
    t.integer "question20"
    t.integer "question21"
    t.integer "question22"
    t.integer "question23"
    t.integer "question24"
    t.integer "question25"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_questionnaires_on_user_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followed_id"
    t.integer "total_score"
    t.integer "positive"
    t.integer "faithful"
    t.integer "cooperative"
    t.integer "mental"
    t.integer "curious"
    t.integer "background"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_id"], name: "index_relationships_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "questionnaires", "users"
end
