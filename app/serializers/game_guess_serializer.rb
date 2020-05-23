class GameGuessSerializer < ActiveModel::Serializer 
    attributes :id, :guess_letter, :guesser_game_user_id, :target_game_user_id
    belongs_to :guesser_game_user, class_name: "GameUser"# foreign_key: "guesser_game_user_id",
    belongs_to :target_game_user, class_name: "GameUser"# foreign_key: "target_game_user_id",
end