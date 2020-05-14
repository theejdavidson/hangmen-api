class GamesChannel < ApplicationCable::Channel
    def subscribed
        game = Game.find_by(key: params[:key])
        stream_for game
    end

    def unsubscribed
    end
end