extends CanvasLayer

signal create_game
signal join_game
var player_name
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass




func _on_CreateGameButton_pressed():
	emit_signal("create_game", player_name)


func _on_JoinGameButton_pressed():
	emit_signal("join_game", player_name)
