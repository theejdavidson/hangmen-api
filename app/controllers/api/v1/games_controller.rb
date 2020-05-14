class Api::V1::GamesController < ApplicationController
    # skip_before_action :authorized, only: [:create, :join]

    def create
        # @game = Game.new(game_params)
        # byebug
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
            @game_user = GameUser.create(game_id: @game.id, user_id: params[:game][:users][:id])
            broadcast_game
        else
            render json: { error: 'could not find game with that key'}, status: :not_acceptable
        end
    end

    private

    # def game_params
    #     params.require(:game).permit(:key, :users)
    # end

    def broadcast_game
        serialized_game_data = ActiveModelSerializers::Adapter::Json.new(
        GameSerializer.new(@game)).serializable_hash
        ActionCable.server.broadcast 'games_channel', serialized_game_data
        head :ok
    end
end