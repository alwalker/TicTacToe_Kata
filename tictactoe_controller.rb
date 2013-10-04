require 'couchrest'
require 'json'

class TicTacToeController
	def self.create_new_game(playerId) 
		if (playerId.nil? || playerId.empty?)
			return [500, 'Invalid playerId']
		end

		begin
			db = CouchRest.database('https://alwalker.cloudant.com/ttgp_poc_db/')
		rescue => e
			@logger.error("Error retrieving database: #{$!}")
			@logger.error("Backtrace:\n\t#{e.backtrace.join("\n\t")}")
			return [500, "Couldn't retrieve database"]
		end

		game = {
			'_id' => SecureRandom.uuid,
			'players' => [playerId],
			'board' => [[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]]
		}

		begin
			db.save_doc(game)
		rescue => e
			@logger.error("Error saving game: #{$!}")
			@logger.error("Backtrace:\n\t#{e.backtrace.join("\n\t")}")
			return [500, "Couldn't save game"]
		end

		return [200, game.to_json]
	end

	def self.add_player_to_game(gameId, playerId)
		if (playerId.nil? || playerId.empty?)
			return [500, 'Invalid playerId']
		end
		if (gameId.nil? || gameId.empty?)
			return [500, 'Invalid gameId']
		end

		begin
			db = CouchRest.database('https://alwalker.cloudant.com/ttgp_poc_db/')
		rescue => e
			@logger.error("Error retrieving database: #{$!}")
			@logger.error("Backtrace:\n\t#{e.backtrace.join("\n\t")}")
			return [500, "Couldn't retrieve database"]
		end		
		begin
			game = db.get(gameId)
		rescue => e
			@logger.error("Error retrieving game: #{$!}")
			@logger.error("Backtrace:\n\t#{e.backtrace.join("\n\t")}")
			return [500, "Couldn't retrieve game"]
		end

		if (game['players'].length >= 2)
			return [500, 'Game is already full']
		end
		if(game['players'].length == 1 && game['players'][0] == playerId)
			return [500, 'This player is already playing']
		end
		game['players'].push(playerId)

		begin
			db.save_doc(game)
		rescue => e
			@logger.error("Error saving game: #{$!}")
			@logger.error("Backtrace:\n\t#{e.backtrace.join("\n\t")}")
			return [500, "Couldn't save game"]
		end

		return [200, game.to_json]
	end

	def self.delete_game(gameId)
		if (gameId.nil? || gameId.empty?)
			return [500, 'Invalid gameId']
		end

		begin
			db = CouchRest.database('https://alwalker.cloudant.com/ttgp_poc_db/')
		rescue => e
			@logger.error("Error retrieving database: #{$!}")
			@logger.error("Backtrace:\n\t#{e.backtrace.join("\n\t")}")
			return [500, "Couldn't retrieve database"]
		end		
		begin
			game = db.get(gameId)
		rescue => e
			@logger.error("Error retrieving game: #{$!}")
			@logger.error("Backtrace:\n\t#{e.backtrace.join("\n\t")}")
			return [500, "Couldn't retrieve game"]
		end

		begin
			db.delete_doc(game)
		rescue => e
			@logger.error("Error deleting game: #{$!}")
			@logger.error("Backtrace:\n\t#{e.backtrace.join("\n\t")}")
			return [500, "Couldn't delete game"]
		end

		return 200
	end
end