extends Node

export (PackedScene) var GameBoard
export (PackedScene) var MainMenu


# Declare member variables here. Examples:
const PORT = 8499
var hostname = "localhost"
const MAX = 30
#var _server = WebSocketServer.new()
var games = []
var enteredname
var network = NetworkedMultiplayerENet.new()
var players = {}
var player_data = {player_name = '', player_score = 0}


# Called when the node enters the scene tree for the first time.
func _ready():
	#var error = _server.listen(PORT)
	#if error != OK:
		#print("Unable to start server")
	#print(hostname)
	network.create_server(PORT, MAX)
	get_tree().set_network_peer(network)
	print("Server Started")
	network.connect("peer_connected", self, "_Peer_Connected")
	network.connect("peer_disconnected", self, "_Peer_Disconnected")
	


func _Peer_Connected():
	print("Player connected")

func _Peer_Disconnected():
	print("Player disconnected")



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartButton_pressed():
	var gameboard = preload("res://GameBoard.tscn").instance()
	add_child(gameboard) 
	gameboard.hidebuttons()
	print("Does this print out??")




func _on_RegisterPage_name_entered():
	enteredname = $RegisterPage/NameEntryBox.get_text()
	var mainmenu = preload("res://MainMenu.tscn").instance()
	add_child(mainmenu)
	
