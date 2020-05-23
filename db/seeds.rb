# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
testGame1 = Game.create(key: 'testGame1')
testGame2 = Game.create(key: 'testGame2')

bob = User.create(username: 'bob', password: 'bob' )
alice = User.create(username: 'alice', password: 'alice' )
sam = User.create(username: 'sam', password: 'sam' )
jill = User.create(username: 'jill', password: 'jill' )

bobGame1 = GameUser.create(game_id: testGame1.id, user_id: bob.id, guess_word: 'sashimi')
aliceGame1 = GameUser.create(game_id: testGame1.id, user_id: alice.id, guess_word: 'pizza')
samGame1 = GameUser.create(game_id: testGame1.id, user_id: sam.id, guess_word: 'burger')

puts "GAMEUSER bob CREATED: #{bobGame1.id}"
puts "GAMEUSER alice CREATED: #{aliceGame1.id}"


bobGuess1 = GameGuess.create!(guess_letter: 'f', guesser_game_user_id: bobGame1.id, target_game_user_id: aliceGame1.id, game_id: 1)

# bobGame1.map_guess_word