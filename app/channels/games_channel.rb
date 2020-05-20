class GamesChannel < ApplicationCable::Channel
    def subscribed
        Rails.logger.info "LEV #{Rails.logger.level} vs #{Logger::INFO}: GamesChannel.`subscribed`"
        @game = Game.find_by(key: params[:key])
        # byebug

        stream_for @game
        broadcast_update()
    end

    def received(data)
        Rails.logger.info "GamesChannel.`received` -> #{data}"
        broadcast_update()
    end

    def unsubscribed
        stop_all_streams
    end

    private
    def broadcast_update()
        serialized_game_data = ActiveModelSerializers::Adapter::Json.new(
            GameSerializer.new(@game)).serializable_hash
            GamesChannel.broadcast_to(@game, serialized_game_data)
    end
end