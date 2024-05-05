extends Node3D


var pos = -1

var numShadows = 0

var canSee = false

func _ready():
	numShadows = get_children().size()
	for N in get_children():
		N.hide()
	pass
	
func increasePos():
	pos += 1
	updatePos()
	if (pos >= numShadows):
		pos = -1
	pass
func decreasePos():
	if (pos < -1):
		return
	pos -= 1
	updatePos()
	pass

func updatePos():
	for N in get_children():
		N.hide()

	if (pos < numShadows and pos >= 0):
			get_children()[pos].show()
			


func _process(delta):
	print("Moved to pos: " + str(pos) + " and visibility:" + str(canSee))
	if (canSee):
		show()
	else:
		hide()
	pass
