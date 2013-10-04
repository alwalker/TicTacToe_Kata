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




	def to_json
		return {'id' => @id, 'players' => @players, 'board' => @board}.to_json
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
end