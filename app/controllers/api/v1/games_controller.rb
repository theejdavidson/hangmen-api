class Api::V1::GamesController < ApplicationController
    skip_before_action :authorized#, only: [:create, :join, :guess, :start]

    def create
        @game = Game.create(key: params[:inviteKey])
        @game_user = GameUser.create(game_id: @game.id, user_id: params[:user][:id], guess_word: params[:guessWord])

        if @game.valid? && @game_user.valid?
            broadcast_game
        else
          render json: { error: 'failed to create game' }, status: :not_acceptable
        end
    end

    def join
        @game = Game.find_by(key: params[:inviteKey])
        if @game
            if @game.status == 'PLAYERS_JOINING'
                @game_user = GameUser.find_or_create_by(game_id: @game.id, user_id: params[:user][:id], guess_word: params[:guessWord])
                broadcast_game
            else
                render json: { error: "game with invite key #{@game.key} is currently #{@game.status}"}, status: :not_acceptable
            end
        else
            render json: { error: 'could not find game with that key'}, status: :not_acceptable
        end
    end

    def start
        @game = Game.find(params[:gameId])
        @game.update(status: 'IN_PROGRESS')
        @game.save
        broadcast_game
    end

    def guess
        @guess = GameGuess.create(guess_letter: params[:guessLetter], guesser_game_user_id: params[:guesserGameUserId], target_game_user_id: params[:targetGameUserId], game_id: params[:gameId])
        @guesser_game_user = GameUser.find(params[:guesserGameUserId])
        @target_game_user = GameUser.find(params[:targetGameUserId])
        @game = Game.find(params[:gameId])

        if !@target_game_user.guess_word.include?(@guess.guess_letter) && @guesser_game_user.limbs < 6
            @guesser_game_user.increment!(:limbs, 1)
        end
        broadcast_game
    end

    private

    def broadcast_game
        serialized_game_data = ActiveModelSerializers::Adapter::Json.new(
            GameSerializer.new(@game)
        ).serializable_hash

        Rails.logger.info "Ruby broadcasting -> #{serialized_game_data}"

        GamesChannel.broadcast_to(@game, serialized_game_data)
        head :ok

    end
end