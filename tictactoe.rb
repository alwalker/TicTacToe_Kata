require 'couchrest'
require 'json'
require 'logger'

class TicTacToe
	def initialize(board, players, db)
		@logger = Logger.new(STDOUT)
		@logger.level = Logger::DEBUG

		@id = SecureRandom.uuid
		@board = board
		@players = players
		@db = db
	end

	def initialize(id, rev, board, players, db)
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
		game.save

		return game
	end

	def self.get_existing_game(gameId)
		if (gameId.nil? || gameId.empty?)
			return [500, 'Invalid gameId']
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

		return TicTacToe.new(game['_id'], game['_rev'], game['board'], game['players'], db)
	end




	def to_json
		return {'id' => @id, 'players' => @players, 'board' => @board}.to_json
	end

	def save
		begin
			@db.save_doc({'_id' => @id, 'players' => @players, 'board' => @board})
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