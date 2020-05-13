class GameSerializer < ActiveModel::Serializer
    attributes :id, :key
    has_many :users
  end
  