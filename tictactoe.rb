require 'couchrest'
require 'json'
require 'logger'

class TicTacToe
	def initialize(board, players, db, id=SecureRandom.uuid, rev=nil)
		@logger = Logger.new(STDOUT)
		@logger.level = Logger::DEBUG

		@id = id
		@rev = rev
		@board = board
		@players = players
		@db = db
	end

	def self.create_new_game(playerId)
		if (playerId.nil? || playerId.empty?)
			raise ArgumentError, 'Invalid playerId'
		end

		begin
			db = CouchRest.database('https://alwalker.cloudant.com/ttgp_poc_db/')
		rescue => e
			@logger.error("Error retrieving database: #{$!}")
			@logger.error("Backtrace:\n\t#{e.backtrace.join("\n\t")}")
			raise 'Could not retrieve database'
		end

		game = TicTacToe.new([[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]], [playerId], db)		

		return game
	end

	def self.get_existing_game(gameId)
		if (gameId.nil? || gameId.empty?)
			raise ArgumentError, 'Invalid gameId'
		end

		begin
			db = CouchRest.database('https://alwalker.cloudant.com/ttgp_poc_db/')
		rescue => e
			@logger.error("Error retrieving database: #{$!}")
			@logger.error("Backtrace:\n\t#{e.backtrace.join("\n\t")}")
			raise 'Could not retrieve database'
		end

		begin
			game = db.get(gameId)
		rescue RestClient::ResourceNotFound
			raise 'Game does not exist'
		rescue => e
			@logger.error("Error retrieving game: #{$!}")
			@logger.error("Backtrace:\n\t#{e.backtrace.join("\n\t")}")
			raise 'Could not retrieve game'
		end

		return TicTacToe.new(game['board'], game['players'], db, game['_id'], game['_rev'])
	end



	def add_player(playerId)
		if (playerId.nil? || playerId.empty?)
			raise ArgumentError, 'Invalid playerId'
		end

		if (@players.length >= 2)
			raise 'Game is already full'
		end

		if(@players.length == 1 && @players[0] == playerId)
			raise 'This player is already playing'
		end

		@players.push(playerId)
	end

	def move (move)
		if @players.length != 2
			raise 'Wrong number of players'
		end

		xturn = oturn = false
		xs, os = get_x_o_count

		if xs == os
			xturn = true
		elsif (xs > os)
			yturn = true
		else
			raise 'Board in invalid state'
		end

		if xturn and move.player != @players[0]
			raise 'Wrong player'
		end

		if yturn and move.player != @players[1]
			raise 'Wrong player'
		end

		if @board[move.x][move.y].nil?
			@board[move.x][move.y] = xturn ? 'X' : 'O'
		else
			raise 'This position has already been played'
		end

		return check_for_end
	end	

	def save
		begin
			if @rev.nil?
				@db.save_doc({'_id' => @id, 'players' => @players, 'board' => @board})
			else				
				@db.save_doc({'_id' => @id, '_rev' => @rev, 'players' => @players, 'board' => @board})
			end
		rescue => e
			@logger.error("Error saving game: #{$!}")
			@logger.error("Backtrace:\n\t#{e.backtrace.join("\n\t")}")
			raise 'Could not save game'
		end
	end

	def delete
		begin
			@db.delete_doc({'_id' => @id, '_rev' => @rev, 'players' => @players, 'board' => @board})
		rescue => e
			@logger.error("Error deleting game: #{$!}")
			@logger.error("Backtrace:\n\t#{e.backtrace.join("\n\t")}")
			raise 'Could not delete game'
		end
	end

	def to_json
		return {'id' => @id, 'players' => @players, 'board' => @board}.to_json
	end

	private

	def get_x_o_count
		xs = 0
		os = 0

		@board.each {|row| row.each {|col| if col == 'X' then xs = xs + 1 elsif col == 'O' then os = os + 1 end}}

		return xs, os
	end

	def check_for_end
		if @board[0][0] == @board[0][1] && @board[0][0] == @board[0][2]
			return true
		elsif @board[1][0] == @board[1][1] && @board[1][0] == @board[1][2]
			return true
		elsif @board[2][0] == @board[2][1] && @board[2][0] == @board[2][2]
			return true
		elsif @board[0][0] == @board[1][0] && @board[0][0] == @board[2][0]
			return true
		elsif @board[0][1] == @board[1][1] && @board[0][1] == @board[1][2]
			return true
		elsif @board[0][2] == @board[1][2] && @board[0][2] == @board[2][2]
			return true
		elsif @board[0][0] == @board[1][1] && @board[0][0] == @board[2][2]
			return true
		elsif @board[2][0] == @board[1][1] && @board[2][0] == @board[0][2]
			return true
		else
			return false
		end			
	end
end