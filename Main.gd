extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the game is opened
func _ready():
	var launchpage = preload("res://LaunchPage.tscn").instance()
	# Add the launch page to the Scene Tree
	add_child(launchpage)
	launchpage.connect("launch_server", self, "_launch_server")
	launchpage.connect("join_server", self, "_join_server")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#This function launches the server when the button is
#pressed on the launch page
func _launch_server():
	print("in launch server func")
	var registerpage = preload("res://RegisterPage.tscn").instance()
	add_child(registerpage)
	registerpage.connect("name_entered", self, "_name_entered")
	#$Server.create_server("rose")


#This function is called when the user name is entered
# on the register page
func _name_entered(name):
	#get_tree().get_current_scene().name
	$Server.create_server(name)
	var mainmenu = preload("res://MainMenu.tscn").instance()
	add_child(mainmenu)
	mainmenu.player_name = name
	mainmenu.connect("create_game", self, "_create_game")
	mainmenu.connect("join_game", self, "_join_game")

#This function is called when a user clicks "Join Server"
# button on the launch page
func _join_server():
	var joinserverpage = preload("res://JoinServer.tscn").instance()
	add_child(joinserverpage)
	joinserverpage.connect("server_name_entered", self, "_server_name_entered")

# This function is called when a user enteres a server name
# on the join server page
func _server_name_entered(servername):
	var registerpage = preload("res://RegisterPage.tscn").instance()
	add_child(registerpage)
	registerpage.connect("name_entered", self, "join_name_entered")

# This function is called when a joining user enteres 
# their name on the registration page
func join_name_entered(name):
	$Server.connect_to_server(name,"10.0.0.249")
	var mainmenu = preload("res://MainMenu.tscn").instance()
	add_child(mainmenu)
	mainmenu.player_name = name
	mainmenu.connect("create_game", self, "_create_game")
	mainmenu.connect("join_game", self, "_join_game")

# This function is called when the create button is pressed
# on the main menu page
func _create_game(name):
	print_tree()
	$Server.create_game(name)
	for game in $Server.games:
		print($Server.games[game].gameid)


# This function is called when the Server emits an open
# game signal
func _on_Server_open_game(id):
	print("open game function")
	add_child($Server.games[id])
	$Server.games[id].connect("move_made", $Server, "update_board")
	$Server.games[id].connect("exit", self, "exit_game")

# This funciton is called when player1 of a game
# (The user that created the game) exits a game using the
# exit button
func exit_game(id):
	print("in exit game funciton")
	remove_child($Server.games[id])
	$Server.games.erase(id)

# This function is called when a user clicks Join Game 
# on the main menu page
func _join_game(name):
	print("in join game")
	#for game in $Server.games:
	if $Server.get_tree().is_network_server():
		var joingame = preload("res://JoinGame.tscn").instance()
		add_child(joingame)
		joingame.connect("back_to_main", self, "_back_to_main")
		var position = 40
		for game in $Server.games:
			var button = Button.new()
			button.text = $Server.games[game].player1
			button.connect("pressed", self, "_game_selected", [game, name])
			button.set_position(Vector2(0,position))
			position = position + 40
			joingame.add_child(button)
	else:
		$Server.get_games()
		print("return from get_games")

#This function is called when a user clicks on an open game
# on the join game page
func _game_selected(gameid, name):
	add_child($Server.games[gameid])
	$Server.games[gameid].connect("move_made", $Server, "update_score")
	$Server.games[gameid].get_node('Waiting').hide()
	$Server.games[gameid].player2 = name
	$Server.games[gameid].connect("exit", self, "exit_game_2")
	$Server.games[gameid].numplayers = 2
	$Server.join_game(gameid)

# This function is called when player2 
# (The player who joined a game) exits the game
# using the exit button
func exit_game_2(id):
	print("in exit game funciton 2")
	remove_child($Server.games[id])

func _back_to_main():
	remove_child(get_node('JoinGame'))


func _on_Server_games_received():
	print("In games received")
	for game_id in $Server.game_data:
		var game = preload("res://GameBoard.tscn").instance()
		$Server.games[game_id] = game
		$Server.games[game_id].player1 = $Server.game_data[game_id]
	var joingame = preload("res://JoinGame.tscn").instance()
	add_child(joingame)
	joingame.connect("back_to_main", self, "_back_to_main")
	var position = 40
	for game in $Server.games:
		var button = Button.new()
		button.text = $Server.games[game].player1
		button.connect("pressed", self, "_game_selected", [game, name])
		button.set_position(Vector2(0,position))
		position = position + 40
		joingame.add_child(button)
