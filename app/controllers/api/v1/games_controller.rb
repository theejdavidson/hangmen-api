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
        @guesser_game_user = GameUser.find(params[:guesserGameUserId])
        @target_game_user = GameUser.find(params[:targetGameUserId])
        @game = Game.find(params[:gameId])
        if @guesser_game_user.limbs < 6
            @guess = GameGuess.create(guess_letter: params[:guessLetter], guesser_game_user_id: params[:guesserGameUserId], target_game_user_id: params[:targetGameUserId], game_id: params[:gameId])
            target_total_guesses = @game.game_guesses.filter{|guess| guess.target_game_user_id == @target_game_user.id}.map{|guess| guess.guess_letter}
            target_guess_word_arr = @target_game_user.guess_word.split('')
            remaining_target_letters = target_guess_word_arr.filter{|letter| !target_total_guesses.include?(letter)}
            if remaining_target_letters.length == 0
                @target_game_user.limbs = 6
                @target_game_user.save 
            end
            if !@target_game_user.guess_word.include?(@guess.guess_letter)
                @guesser_game_user.increment!(:limbs, 1)
            end
        end
        remaining_users = @game.game_users.filter{ |user| user.limbs != 6}
        if remaining_users.length == 1
            @game.update(status: 'FINISHED')
            @game.save
        end
        # byebug
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