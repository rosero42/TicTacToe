extends Node
# Declare member variables here. Examples:
const PORT = 8499
var hostname = "localhost"
const MAX = 30
var games = {}
var gamenums = 0
var players = {}
var player_data = {name = '', player_score = 0}
signal open_game
signal games_received
var game_data = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().connect('network_peer_disconnected', self, '_on_player_disconnected')
	get_tree().connect('network_peer_connected', self, '_on_player_connected')

# This function is called from main when a user 
# launches a server
func create_server(player_name):
	player_data.name = player_name
	players[1] = player_data
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(PORT, MAX)
	get_tree().set_network_peer(peer)
	print("Server launched")

# This function is called when a user joins a server
func connect_to_server(player_name, ip):
	player_data.name = player_name
	get_tree().connect('connected_to_server', self, '_connected_to_server')
	get_tree().connect('connection_failed', self, '_connection_failed')
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(ip, PORT)
	get_tree().set_network_peer(peer)
	print("client connected")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# This function is called when a connection is not made
# to the server
func _connection_failed():
	print("Failed to connect to server")

# This function is called automatically when
# the client connects to the server (called from client)
func _connected_to_server():
	var local_player_id = get_tree().get_network_unique_id()
	players[local_player_id] = player_data
	rpc('_send_player_info', local_player_id, player_data)

# This function is called automatically when a client
# disconnects (called from server)
func _on_player_disconnected(id):
	players.erase(id)
	print("player disconnected")

# This function is called from both client and server
# when client connects to server
func _on_player_connected(connected_player_id):
	var local_player_id = get_tree().get_network_unique_id()
	if not(get_tree().is_network_server()):
		# Since only one user exists as root user of server
		# we know we can request user 1
		rpc_id(1, '_request_player_info', local_player_id, connected_player_id)

# This funtion is called through rpc pipes to request the player info
# from both server and client
remote func _request_player_info(request_from_id, player_id):
	if get_tree().is_network_server():
		#print(request_from_id.get_object_id())
		rpc_id(request_from_id, '_send_player_info', player_id, players[player_id])

# This function is called through rpc pipes
remote func _request_players(request_from_id):
	if get_tree().is_network_server():
		for peer_id in players:
			if( peer_id != request_from_id):
				rpc_id(request_from_id, '_send_player_info', peer_id, players[peer_id])

remote func _send_player_info(id, info):
	players[id] = info
	var new_player = load('res://Player.tscn').instance()
	new_player.name = str(id)
	new_player.set_network_master(id)
	$'/root/'.add_child(new_player)
	new_player.init(info.name)
	if get_tree().is_network_server():
		for player in players:
			print(players[player])

func create_game(name):
	#var newgame = preload("res://GameBoard.tscn").instance()
	if not get_tree().is_network_server():
		var local_game_id = get_tree().get_network_unique_id()
		#newgame.gameid = local_game_id
		#games[newgame.gameid] = newgame
		rpc('_send_game_info',local_game_id,name)
		var new_game = preload("res://GameBoard.tscn").instance()
		games[local_game_id] = new_game
		print(local_game_id)
		new_game.gameid = local_game_id
		new_game.player1 = name
		game_data[local_game_id] = name
		emit_signal("open_game", local_game_id)
	else:
		var game_id = get_tree().get_network_unique_id()
		print("game id: " + str(game_id))
		var new_game = preload("res://GameBoard.tscn").instance()
		games[game_id] = new_game
		new_game.gameid = game_id
		new_game.player1 = name
		game_data[game_id] = name
		emit_signal("open_game", game_id)

remote func _send_game_info(id,name):
	var new_game = preload("res://GameBoard.tscn").instance()
	new_game.gameid = id
	games[id] = new_game
	new_game.player1 = name
	new_game.set_network_master(id)

func join_game(gameid):
	rpc('_start_game', gameid)

remote func _start_game(gameid):
	games[gameid].showbuttons()
	games[gameid].get_node('Waiting').hide()

func get_games():
	var local_request_id = get_tree().get_network_unique_id()
	rpc_id(1, 'send_games', local_request_id)

remote func send_games(local_request_id):
	print("in remote func")
	if get_tree().is_network_server():
		for game_id in game_data:
			if( game_id != local_request_id):
				rpc_id(local_request_id, 'sending_games', local_request_id, game_data[game_id])

remote func sending_games(id, info):
	print("in sending games")
	game_data[id] = info
	print(id)
	print(info)
	emit_signal("games_received")
