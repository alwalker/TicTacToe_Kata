require 'sinatra'
require './tictactoe_controller'

get '/' do
	"Hello World!"
end

post '/tictactoe/:playerId' do
	return TicTacToeController.create_new_game(params[:playerId])
end

put '/tictactoe/:gameId/addPlayer/:playerId' do
	return TicTacToeController.add_player_to_game(params[:gameId], params[:playerId])
end
