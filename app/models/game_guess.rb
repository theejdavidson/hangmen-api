class GameGuess < ApplicationRecord
    belongs_to :guesser_game_user, foreign_key: "guesser_game_user_id", class_name: "GameUser"
    belongs_to :target_game_user, foreign_key: "target_game_user_id", class_name: "GameUser"
    belongs_to :game
end