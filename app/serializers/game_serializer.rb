class GameSerializer < ActiveModel::Serializer
    attributes :id, :key
    has_many :game_users
    has_many :users, :through => :game_users
    has_many :game_guesses
  end
  