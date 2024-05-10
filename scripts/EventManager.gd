extends Node

@onready var filesystem = get_node("../FileSystem")
@onready var shadows = get_node("../World/Shadows")
@onready var console = get_node("../Console")
@onready var consoletext = get_node("../Console/ConsoleText")
@onready var security = get_node("../Console/Security")

@export_multiline var text1 : String = ""
@export_multiline var text2 : String = ""
@export_multiline var text3 : String = ""


var folder = load("res://scenes/folder.tscn")
var textfile = load("res://scenes/textfile.tscn")

var timer = 0
var shadowPos = 0

var created_text = 0

func _ready():
	pass
	

func _process(delta):
	timer += delta
	if (timer > 2):
		var r = randi_range ( 0, 20 )
		if (r < 3):
			eventTrigger()
		timer = 0
	pass

func createFile(name, text):
	consoletext.scroll_text("\n-----------------\nNEW FILE CREATED\n-----------------\n")
	var val = textfile.instantiate()
	val.name = name
	val.text = text
	console.activeFolder.add_child(val)
	created_text+=1

func eventTrigger():
	$beep.play()
	if (absi(security.activeCamera-shadows.pos) < 2):
		security.disabled = true
	
	if (randf_range(0,1.0) < 0.7):
		if (randf_range(0,1.0) < 0.8):
			shadows.canSee = true
		else:
			shadows.canSee = false
	
	if (randf_range(0,1.0) < 0.9):
		shadows.increasePos()
	else:
		shadows.decreasePos()
	
	if (randf_range(0,1.0) < 0.15):
		if (created_text == 0):
			createFile("hello.txt", text1+"\n")
		elif (created_text == 1):
			createFile("hide.txt", text2+"\n")
		elif (created_text == 2):
			createFile("escape.txt", text3+"\n")
		pass
	pass
