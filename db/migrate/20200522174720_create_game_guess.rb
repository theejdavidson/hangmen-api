class CreateGameGuess < ActiveRecord::Migration[6.0]
  def change
    create_table :game_guesses do |t|
      t.string :guess_letter
      t.references :guesser_game_user, null: false, index: true, foreign_key: { to_table: :game_users }
      t.references :target_game_user, null: false, index: true, foreign_key: { to_table: :game_users }
    end
  end
end
