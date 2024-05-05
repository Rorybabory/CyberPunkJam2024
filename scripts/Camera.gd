extends Camera3D


@export var range : float = 30

var rot = Vector3(0,0,0)

var timer = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	rot = rotation_degrees
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	rotation_degrees = rot + Vector3(0,sin(timer*0.5)*30.0,0)
	pass
