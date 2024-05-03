extends RichTextLabel

var vischars = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	bbcode_enabled = true
	pass # Replace with function body.


func scroll_text(input_text : String):
	vischars = text.length()-1.0
	text += input_text
	
#	text = "[color=red]"+text+"[/color]"
	
	#for i in range(input_text.length()):
	#	await get_tree().create_timer(0.0001).timeout
	 

func _physics_process(delta):
	if (vischars < text.length()):
		vischars+=delta*200.0
		pass
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	visible_characters = int(vischars)
	pass
