extends Node2D


# Declare member variables here. Examples:
const PORT = 78499
var hostname = "localhost"
const MAX = 2
var _server = WebSocketServer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	var error = _server.listen(PORT)
	if error != OK:
		print("Unable to start server")
	print("hostname")



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
