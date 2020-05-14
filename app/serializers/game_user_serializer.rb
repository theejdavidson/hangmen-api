class GameUserSerializer < ActiveModel::Serializer
    attributes :id, :game_id, :user_id, :guess_word
    belongs_to :game
    belongs_to :user
  end