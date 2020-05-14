class Api::V1::GamesController < ApplicationController

    def create
        @game = Game.create(key: params[:game][:key])
        @game_user = GameUser.create(game_id: @game.id, user_id: params[:game][:users][:id])

        if @game.valid? && @game_user.valid?
            broadcast_game
        else
          render json: { error: 'failed to create game' }, status: :not_acceptable
        end
    end

    def join
        @game = Game.find_by(key: params[:key])
        if @game
            @game_user = GameUser.create(game_id: @game.id, user_id: params[:user][:id])
            broadcast_game
        else
            render json: { error: 'could not find game with that key'}, status: :not_acceptable
        end
    end

    private

    def broadcast_game
        serialized_game_data = ActiveModelSerializers::Adapter::Json.new(
        GameSerializer.new(@game)).serializable_hash
        ActionCable.server.broadcast 'GamesChannel', serialized_game_data
        render json: serialized_game_data
    end
end