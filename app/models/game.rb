class Game < ApplicationRecord
    has_many :game_users
    has_many :users, :through => :game_users
    has_many :game_guesses
    accepts_nested_attributes_for :users
end
