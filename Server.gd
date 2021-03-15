extends Node



# Declare member variables here. Examples:
const PORT = 8499
var hostname = "localhost"
const MAX = 30
#var _server = WebSocketServer.new()
var games = []
var gamenums = 0
var enteredname
#var network = NetworkedMultiplayerENet.new()
var players = {}
var player_data = {name = '', player_score = 0}


# Called when the node enters the scene tree for the first time.
func _ready():
	#var error = _server.listen(PORT)
	#if error != OK:
		#print("Unable to start server")
	#print(hostname)
	#network.create_server(PORT, MAX)
	#get_tree().set_network_peer(network)
	#print("Server Started")
	#network.connect("peer_connected", self, "_Peer_Connected")
	#network.connect("peer_disconnected", self, "_Peer_Disconnected")
	get_tree().connect('network_peer_disconnected', self, '_on_player_disconnected')
	get_tree().connect('network_peer_connected', self, '_on_player_connected')


func create_server(player_name):
	player_data.name = player_name
	players[1] = player_data
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(PORT, MAX)
	get_tree().set_network_peer(peer)
	print("Server launched")

func connect_to_server(player_name, ip):
	player_data.name = player_name
	get_tree().connect('connected_to_server', self, '_connected_to_server')
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(ip, PORT)
	get_tree().set_network_peer(peer)
	print("client connected")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartButton_pressed():
	var gameboard = preload("res://GameBoard.tscn").instance()
	add_child(gameboard) 
	gameboard.hidebuttons()
	print("Does this print out??")



func _connected_to_server():
	var local_player_id = get_tree().get_network_unique_id()
	players[local_player_id] = player_data
	rpc('_send_player_info', local_player_id, player_data)

func _on_player_disconnected(id):
	players.erase(id)

func _on_player_connected(connected_player_id):
	var local_player_id = get_tree()
	if not(get_tree().is_network_server()):
		rpc_id(1, '_request_player_info', local_player_id, connected_player_id)

remote func _request_player_info(request_from_id, player_id):
	if get_tree().is_network_server():
		print(request_from_id.get_object_id())
		rpc_id(request_from_id.get_object_id(), '_send_player_info', player_id, players[player_id])

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

func create_game():
	var newgame = preload("res://GameBoard.tscn").instance()
	newgame.gameid = gamenums
	gamenums = gamenums + 1
	games[gamenums] = newgame
	if not get_tree().is_network_server():
		_send_game_init()

remote func _send_game_init():
	pass
