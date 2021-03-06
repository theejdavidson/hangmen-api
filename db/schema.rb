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

ActiveRecord::Schema.define(version: 2020_05_24_182114) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "game_guesses", force: :cascade do |t|
    t.string "guess_letter"
    t.bigint "guesser_game_user_id", null: false
    t.bigint "target_game_user_id", null: false
    t.bigint "game_id", null: false
    t.index ["game_id"], name: "index_game_guesses_on_game_id"
    t.index ["guesser_game_user_id"], name: "index_game_guesses_on_guesser_game_user_id"
    t.index ["target_game_user_id"], name: "index_game_guesses_on_target_game_user_id"
  end

  create_table "game_users", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "game_id", null: false
    t.string "guess_word", default: "", null: false
    t.integer "limbs", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["game_id"], name: "index_game_users_on_game_id"
    t.index ["user_id"], name: "index_game_users_on_user_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "key"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "status", default: "PLAYERS_JOINING"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "game_guesses", "game_users", column: "guesser_game_user_id"
  add_foreign_key "game_guesses", "game_users", column: "target_game_user_id"
  add_foreign_key "game_guesses", "games"
  add_foreign_key "game_users", "games"
  add_foreign_key "game_users", "users"
end
