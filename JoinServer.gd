extends CanvasLayer


# Declare member variables here. Examples:
signal server_name_entered
var servername


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_EnterButton_pressed():
	servername = $NameEntryBox.get_text()
	emit_signal("server_name_entered", servername)
