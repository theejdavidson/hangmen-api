class AddLimbsToGameUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :game_users, :limbs, :integer, null: false, default: 0
  end
end
