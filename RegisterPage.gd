extends CanvasLayer


# Declare member variables here. Examples:
var enteredname
signal name_entered


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_EnterButton_pressed():
	enteredname = $NameEntryBox.get_text()
	print(enteredname)
	emit_signal("name_entered")
