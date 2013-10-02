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
end