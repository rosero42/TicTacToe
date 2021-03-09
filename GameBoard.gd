extends CanvasLayer

signal Player1wins
signal Player2wins
signal Tie

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var playernum = 1
var scorematrix = []



# Called when the node enters the scene tree for the first time.
func _ready():
	playernum = 1
	$Player1wins.hide()
	$Player2wins.hide()
	$GameOver.hide()
	$X1.hide()
	$X2.hide()
	$X3.hide()
	$X4.hide()
	$X5.hide()
	$X6.hide()
	$X7.hide()
	$X8.hide()
	$X9.hide()
	$O1.hide()
	$O2.hide()
	$O3.hide()
	$O4.hide()
	$O5.hide()
	$O6.hide()
	$O7.hide()
	$O8.hide()
	$O9.hide()
	$PlayAgainButton.hide()
	$Square1.show()
	$Square2.show()
	$Square3.show()
	$Square4.show()
	$Square5.show()
	$Square6.show()
	$Square7.show()
	$Square8.show()
	$Square9.show()
	for x in range(3):
		scorematrix.append([])
		scorematrix[x] = []
		for y in range(3):
			scorematrix[x].append([])
			scorematrix[x][y] = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func checkscore():
	#Check if there are any moves left
	if playernum > 9:
		emit_signal("Tie")
		return
	## First check rows
	for x in range(3):
		var row = scorematrix[x][0] + scorematrix[x][1] + scorematrix[x][2]
		var mulrow = scorematrix[x][0] * scorematrix[x][1] * scorematrix[x][2]
		if row == 6:
			emit_signal("Player1wins")
			return
		elif row == 3 && mulrow == 1:
			emit_signal("Player2wins")
			return
	## Next check columns
	for y in range(3):
		var col = scorematrix[0][y] + scorematrix[1][y] + scorematrix[2][y]
		var mulcol = scorematrix[0][y] * scorematrix[1][y] * scorematrix[2][y]
		if col == 6:
			emit_signal("Player1wins")
			return
		elif col == 3 && mulcol == 1:
			emit_signal("Player2wins")
			return
	##Check diagonals
	var diag = scorematrix[0][0] + scorematrix[1][1] + scorematrix[2][2]
	var muldiag = scorematrix[0][0] * scorematrix[1][1] * scorematrix[2][2]
	if diag == 6:
		emit_signal("Player1wins")
		return
	elif diag == 3 && muldiag == 1:
		emit_signal("Player2wins")
		return
	diag = scorematrix[0][2] + scorematrix[1][1] + scorematrix[2][0]
	muldiag = scorematrix[0][0] * scorematrix[1][1] * scorematrix[2][2]
	if diag == 6:
		emit_signal("Player1wins")
		return
	elif diag == 3 && muldiag == 1:
		emit_signal("Player2wins")
		return

func _on_ExitButton_pressed():
	get_tree().change_scene("res://Main.tscn") # Replace with function body.


func _on_Square1_pressed():
	if playernum % 2 == 0:
		$O1.show()
		scorematrix[0][0] = 1
	else:
		$X1.show()
		scorematrix[0][0] = 2
	playernum += 1
	$Square1.hide()
	checkscore()



func _on_Square2_pressed():
	if playernum % 2 == 0:
		$O2.show()
		scorematrix[0][1] = 1
	else:
		$X2.show() 
		scorematrix[0][1] = 2
	playernum += 1
	$Square2.hide()
	checkscore()


func _on_Square3_pressed():
	if playernum % 2 == 0:
		$O3.show()
		scorematrix[0][2] = 1
	else:
		$X3.show()
		scorematrix[0][2] = 2
	playernum += 1
	$Square3.hide()
	checkscore()


func _on_Square4_pressed():
	if playernum % 2 == 0:
		$O4.show()
		scorematrix[1][0] = 1
	else:
		$X4.show()
		scorematrix[1][0] = 2
	playernum += 1
	$Square4.hide()
	checkscore()


func _on_Square5_pressed():
	if playernum % 2 == 0:
		$O5.show()
		scorematrix[1][1] = 1
	else:
		$X5.show()
		scorematrix[1][1] = 2
	playernum += 1
	$Square5.hide()
	checkscore()


func _on_Square6_pressed():
	if playernum % 2 == 0:
		$O6.show()
		scorematrix[1][2] = 1
	else:
		$X6.show()
		scorematrix[1][2] = 2
	playernum += 1
	$Square6.hide()
	checkscore()


func _on_Square7_pressed():
	if playernum % 2 == 0:
		$O7.show()
		scorematrix[2][0] = 1
	else:
		$X7.show()
		scorematrix[2][0] = 2
	playernum += 1
	$Square7.hide()
	checkscore()


func _on_Square8_pressed():
	if playernum % 2 == 0:
		$O8.show()
		scorematrix[2][1] = 1
	else:
		$X8.show()
		scorematrix[2][1] = 2
	playernum += 1
	$Square8.hide()
	checkscore()


func _on_Square9_pressed():
	if playernum % 2 == 0:
		$O9.show()
		scorematrix[2][2] = 1
	else:
		$X9.show()
		scorematrix[2][2] = 2
	playernum += 1
	$Square9.hide()
	checkscore()


func _on_GameBoard_Player1wins():
	$Player1wins.show()
	$PlayAgainButton.show()
	hidebuttons()


func _on_GameBoard_Player2wins():
	$Player2wins.show()
	$PlayAgainButton.show()
	hidebuttons()


func _on_PlayAgainButton_pressed():
	_ready()

func hidebuttons():
	$Square1.hide()
	$Square2.hide()
	$Square3.hide()
	$Square4.hide()
	$Square5.hide()
	$Square6.hide()
	$Square7.hide()
	$Square8.hide()
	$Square9.hide()
	



func _on_GameBoard_Tie():
	$GameOver.show()
	$PlayAgainButton.show()
	hidebuttons()
