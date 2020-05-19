class CreateGameUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :game_users do |t|
      t.references :user, null: false, foreign_key: true
      t.references :game, null: false, foreign_key: true
      t.string :guess_word, default: ''
      t.integer :limbs, default: 0

      t.timestamps
    end
  end
end
