class GameUser < ApplicationRecord
  belongs_to :user
  belongs_to :game

  has_many :game_guesses 
  
  # attr_reader :guess_word
  def map_guess_word
    self.guess_word.split('').map { |l| {letter: l, guessed: false} }
  end
end
