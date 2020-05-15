class GamesChannel < ApplicationCable::Channel
    def subscribed
        @game = Game.find_by(key: params[:key])
        # byebug

        stream_for @game
    end

    def received(data)
        serialized_game_data = ActiveModelSerializers::Adapter::Json.new(
        GameSerializer.new(@game)).serializable_hash
        GamesChannel.broadcast_to(@game, serialized_game_data)
    end

    def unsubscribed
    end
end