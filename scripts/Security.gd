extends Node2D

@export var cameras : NodePath = NodePath("")

var activeCamera = 0
var timer = 0
var alarmCam = -1

var disabled = true
var disableTimer = 0

var alarmTimer = 0 

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ($Screen == null):
		return

	if (disabled == true):
		$Screen.material.set_shader_parameter("color", Vector4(0.02,0.02,0.02,1))
		disableTimer+=delta
		if (disableTimer > 1.0):
			disabled = false
			disableTimer = 0
		return
	
	if (alarmCam != activeCamera):
		$Screen.material.set_shader_parameter("color", Vector4(0.2,0.3,0.5,1))
		return
	alarmTimer+=delta
	if (alarmTimer > 4):
		alarmTimer = 0
		alarmCam = -1
	timer += delta
	if (timer < 0.25):
		$Screen.material.set_shader_parameter("color", Vector4(0.4,0.1,0.1,1))
	else:
		$Screen.material.set_shader_parameter("color", Vector4(0.2,0.3,0.5,1))
	if (timer > 0.5):
		$Sound.play()
		timer = 0
	pass
	

func _on_button_pressed():
	self.hide()
	pass # Replace with function body.


func switchCamera():
	var cams = get_node(cameras).get_children()
	var numCams = cams.size()
	cams[activeCamera].current = false
	activeCamera+=1
	if (activeCamera >= numCams):
		activeCamera = 0
	cams[activeCamera].current = true
	for N in range(0,numCams):
		print(cams[N].name)
		pass
	
	pass # Replace with function body.



func _on_alarm_pressed():
	alarmCam = activeCamera
	$Sound.play()
	get_node("../ConsoleText").scroll_text("ALARM ACTIVATED AT CAMERA: " + str(activeCamera) + "\n")
	pass # Replace with function body.
