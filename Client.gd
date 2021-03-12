extends Node2D


# Declare member variables here.
var playername
#var _client = WebSocketClient.new()
var servername
const PORT = 8499
var network = NetworkedMultiplayerENet.new()



# Called when the node enters the scene tree for the first time.
func _ready():
	print("We've entered the client for some god unknown reason")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_JoinServerPage_server_name_entered():
	print("Are we entering this function?")
	servername = $JoinServerPage/NameEntryBox.get_text()
#	var err = _client.connect_to_url(servername)
#	if err != OK:
#		print("Unable to connect")
#		set_process(false)
#	else:
#		print("Successfully connected to server")
	network.create_client(servername,PORT)
	get_tree().set_network_peer(network)
	print("Are we returning from creating the client?")
	network.connect("connection_failed",self, "_Connection_Failed")
	network.connect("connection_succeeded", self, "_Connection_Success")
	


func _Connection_Failed():
	print("Connection Failed")
	

func _Connection_Success():
	print("Connection success")
