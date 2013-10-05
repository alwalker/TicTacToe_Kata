class Move
	def initialize(playerId, x, y)
		@player = playerId
		@x = x
		@y = y
	end

	def player
		@player
	end
	def x
		@x
	end
	def y
		@y
	end

	def self.create_move(body)
		if (body['playerId'].nil? || body['playerId'].empty?)
			raise ArgumentError, 'Invalid playerId'
		else
			playerId = body['playerId']
		end

		if(body['position'].nil? || !body['position'].kind_of?(Array) || body['position'].length != 2)
			raise ArgumentError, 'Invalid position information'
		end

		begin
			x = Integer(body['position'][0])
		rescue
			raise ArgumentError, 'Invalid X coordinate for move'
		end

		begin
			y = Integer(body['position'][1])
		rescue
			raise ArgumentError, 'Invalid Y coordinate for move'
		end

		return Move.new(playerId, x, y)
	end
end