class AddStatusToGames < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :status, :string, default: 'PLAYERS_JOINING'
  end
end
