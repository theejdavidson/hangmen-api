class GameUserSerializer < ActiveModel::Serializer
    attributes :id, :game_id, :user_id, :guess_word, :limbs
    belongs_to :game
    belongs_to :user

    has_many :game_guesses
  end