require './tictactoe'
require './move'

class TicTacToeController
	@@logger = Logger.new(STDOUT)

	def self.initialize
		puts "constructing"
		@@logger.level = Logger::DEBUG
	end

	def self.create_new_game(playerId)
		begin
			game = TicTacToe.create_new_game playerId
			game.save
		rescue => e
			return [500, e.message]
		end

		return [200, game.to_json]
	end

	def self.add_player_to_game(gameId, playerId)
		begin
			game = TicTacToe.get_existing_game gameId
			game.add_player playerId
			game.save
		rescue => e
			return [500, e.message]
		end

		return [200, game.to_json]
	end

	def self.delete_game(gameId)
		begin
			game = TicTacToe.get_existing_game gameId
			game.delete
		rescue => e
			return [500, e.message]
		end

		return 200
	end

	def self.move(gameId, body)
		begin
			game = TicTacToe.get_existing_game gameId
			move = Move.create_move(body)
			ended = game.move(move)
			game.save
		rescue => e
			return [500, e.message]
		end

		if !ended 
			return [200, game.to_json]
		else
			return [200, 'you win!']
		end
	end
end