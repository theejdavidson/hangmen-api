class GameSerializer < ActiveModel::Serializer
    attributes :id, :key
    has_many :game_users
    has_many :users, :through => :game_users

    # def game_users
    #   ActiveModelSerializers::SerializableResource.new(object.game_users,  each_serializer: GameUserSerializer)
    # end
  end
  