extends Node2D

var activeFile

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (activeFile):
		$Title.text = "Text Editor: " + activeFile.name.replace("_", ".")
	else:
		self.hide()


#save and close
func _on_button_pressed():
	self.hide()
	activeFile.text = $TextEditor.text
	pass # Replace with function body.
