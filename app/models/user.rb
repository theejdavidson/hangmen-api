class User < ApplicationRecord
    has_secure_password
    validates :username, uniqueness: { case_sensitive: false }
    has_many :game_users
    has_many :games, :through => :game_users
end
