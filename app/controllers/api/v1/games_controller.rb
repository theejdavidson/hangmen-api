class Api::V1::GamesController < ApplicationController
    skip_before_action :authorized, only: [:create]

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
            @game_user = GameUser.find_or_create_by(game_id: @game.id, user_id: params[:user][:id], guess_word: params[:guessWord])
            broadcast_game
        else
            render json: { error: 'could not find game with that key'}, status: :not_acceptable
        end
    end

    #params: guessLetter, guesserGameUserId, targetGameUserId
    def guess
        @guess = GameGuess.create(guess_letter: params[:guessLetter], guesser_game_user_id: params[:guesserGameUserId], target_game_user_id: params[:targetGameUserId], game_id: params[:gameId])
        # @guesser_game_user = GameUser.find(params[:guesserGameUserId])
        # @target_game_user = GameUser.find(params[:targetGameUserId])
        @game = Game.find(params[:gameId])

        broadcast_game
    end

    #requires params gameUserId
    def increment_limb
        @game_user = GameUser.find(params[:currentGameUserId])
        if @game_user
            @game = Game.find(@game_user.game_id)
            if @game_user.limbs < 6
                @game_user.increment!(:limbs, 1)
                broadcast_game
            end
        else
            render json: { error: 'could not find game user with that id'}, status: :not_acceptable
        end
    end

    # def add_guess_word
    #     # byebug
    #     @game = Game.find_by(key: params[:invite_key])
    #     if @game
    #         @game_user = GmeUser.find_by(user_id: params[:user_id], game_id: @game.id)
    #         if @game_user
    #             @game_user.update(guess_word: params[:guess_word])
    #             @game_user.save
    #             broadcast_game
    #         else
    #             render json: { error: 'could not find game user'}, status: :not_acceptable
    #         end
    #     else
    #         render json: { error: 'could not find game with that key'}, status: :not_acceptable
    #     end
    # end

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