Tic Tac Toe Kata
================
    
     
A simple game of tic tac toe! This is designed to exercies the basics of a web api
+ Some Data Access
+ Simple logic to model as you please
+ Pub/Sub or Polling, your choice!


Must have the following routes
+ POST /tictactoe/:playerId - This creates a new game and returns a unique id for that game
+ PUT /tictactoe/:gameId/addPlayer/:playerId - Adds a player to an existing game
+ DELETE /tictactoe/:gameId - Delete a game
+ POST /tictactoe/:gameId/move - Make a move