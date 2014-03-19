Tic Tac Toe Kata
================
    
     
A simple game of tic tac toe! This is designed to exercies the basics of a web api
+ Some Data Access
+ Simple logic to model as you please
+ Some mechanism for client updates (Pub/Sub or Polling, your choice!)


Must have the following routes
+ POST /tictactoe/:playerId - This creates a new game and returns a unique id for that game
+ PUT /tictactoe/:gameId/addPlayer/:playerId - Adds a player to an existing game
+ DELETE /tictactoe/:gameId - Delete a game
+ POST /tictactoe/:gameId/move - Make a move
+ GET /tictactoe/:gameId - Current game state (if not using some sort of pub/sub mechanism)


For extra fun try some reports!
+ Games won by player (x/o/cat)
+ Games by state (won/tie/open)
+ Games for a given player id
+ Games for a given player id by state (won/lost/tie/open)

Obviously if we were being serious these would be implemented in your data store, but who cares about serious. Maybe you want to learn about your language's data streaming/mapping/etc capabilities.  Maybe you do want to learn about a new data store.  It's up to you!

Different implementation per branch.
