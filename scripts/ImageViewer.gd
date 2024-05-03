extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	setTexture("testImage.jpg")
	self.hide()

func setTexture(path : String):
	$Texture.texture = load("res://textures/" + path)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	self.hide()
	pass # Replace with function body.
