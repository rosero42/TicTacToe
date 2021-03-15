extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var launchpage = preload("res://LaunchPage.tscn").instance()
	add_child(launchpage)
	launchpage.connect("launch_server", self, "_launch_server")
	launchpage.connect("join_server", self, "_join_server")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _launch_server():
	print("in launch server func")
	var registerpage = preload("res://RegisterPage.tscn").instance()
	add_child(registerpage)
	registerpage.connect("name_entered", self, "_name_entered")
	#$Server.create_server("rose")



func _name_entered(name):
	#get_tree().get_current_scene().name
	$Server.create_server(name)
	var mainmenu = preload("res://MainMenu.tscn").instance()
	add_child(mainmenu)
	mainmenu.connect("create_game", self, "_create_game")
	mainmenu.connect("join_game", self, "_join_game")

func _join_server():
	var joinserverpage = preload("res://JoinServer.tscn").instance()
	add_child(joinserverpage)
	joinserverpage.connect("server_name_entered", self, "_server_name_entered")

func _server_name_entered(servername):
	var registerpage = preload("res://RegisterPage.tscn").instance()
	add_child(registerpage)
	registerpage.connect("name_entered", self, "join_name_entered")

func join_name_entered(name):
	$Server.connect_to_server(name,"10.0.0.249")
	var mainmenu = preload("res://MainMenu.tscn").instance()
	add_child(mainmenu)
	mainmenu.connect("create_game", self, "_create_game")
	mainmenu.connect("join_game", self, "_join_game")

func _create_game():
	$Server.create_game()
