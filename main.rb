require 'sinatra'
require './tictactoe_controller'

get '/' do
	"Hello World!"
end

post '/tictactoe/:playerId' do
	return TicTacToeController.create_new_game(params[:playerId])
end
