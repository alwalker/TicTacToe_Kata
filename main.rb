require 'sinatra'
require 'json'
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

delete '/tictactoe/:gameId' do
	return TicTacToeController.delete_game(params[:gameId])
end

post '/tictactoe/:gameId/move' do
	request.body.rewind
	return TicTacToeController.move(params[:gameId], JSON.parse(request.body.read))
end
