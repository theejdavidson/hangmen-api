class AddGameIdToGameGuess < ActiveRecord::Migration[6.0]
  def change
    add_reference :game_guesses, :game, null: false, foreign_key: true
  end
end
