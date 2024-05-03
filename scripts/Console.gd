extends Node2D

var infocus = false

var folder = load("res://scenes/folder.tscn")
var textfile = load("res://scenes/textfile.tscn")

var lastcommands = []

var lastindex = 0

var editorNode

@export var startText: String = "Station 37 (Workstation Edition)
Version 6.0451.5

"

var helpText = "clear: Clears the console view
help: Opens help menu
cd [path]: Change directories
dir/ls: list files in a directory
cat [text file]: view contents of a text file
mkdir [folder]: create a new folder
edit [file]: opens editor for specific file
"

@onready var activeFolder = get_node("../../FileSystem/user/home")

# Called when the node enters the scene tree for the first time.
func _ready():
	$ConsoleText.scroll_text(startText)
	$TextEdit.grab_focus()
	editorNode = get_node("Editor")
	editorNode.hide()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Path.text = "Path: " + str(activeFolder.get_path()).substr(22)
	if (Input.is_action_just_pressed("enter") and $TextEdit.has_focus()):
		run_command($TextEdit.text)
		$TextEdit.clear()
	pass
	
	
func run_command(str):
	str = str.to_lower()
	
	lastcommands.push_front(str)
	
	$ConsoleText.scroll_text(">"+str)
	str = str.strip_edges()
	var tokens = str.split(" ")
	
	print(str(tokens))
	
	var command = tokens[0]
	
	var arguement = ""
	if tokens.size() > 1:
		arguement = tokens[1]
		arguement = arguement.replace(".", "_")
	
	if (command == "clear"):
		if (tokens.size() != 1):
			return
		$ConsoleText.text = ""
	elif (command == "help"):
		if (tokens.size() != 1):
			return
		$ConsoleText.scroll_text(helpText)
	elif (command == "cd"):
		if (tokens.size() == 2):
			var next = activeFolder.get_node(arguement)
			if (next == null):
				$ConsoleText.scroll_text("[color=red]ERROR: FOLDER NOT FOUND[/color]\n")
				return
			if (next.get_groups().size() != 1):
				$ConsoleText.scroll_text("[color=red]ERROR: INVALID OBJECT[/color]\n")
				return
			if (next.get_groups()[0] == "folder"):
				activeFolder = next
			else:
				$ConsoleText.scroll_text("[color=red]ERROR: NOT A FOLDER[/color]\n")
		else:
			$ConsoleText.scroll_text("[color=red]ERROR: INVALID ARGUEMENTS[/color]\n")
	elif (command == "dir" or command == "ls"):
		if (tokens.size() != 1):
			return
		$ConsoleText.scroll_text("\n")
		for child in activeFolder.get_children():
			$ConsoleText.scroll_text("	-" + child.name.replace("_", ".") + "\n")
	elif (command == "cat"):
		if (tokens.size() != 2):
			$ConsoleText.scroll_text("[color=red]ERROR: INVALID ARGUEMENTS[/color]\n")
			return
		var next = activeFolder.get_node(arguement)
		if (next == null):
			$ConsoleText.scroll_text("[color=red]ERROR: FILE NOT FOUND[/color]\n")
			return
		if (next.get_groups()[0] == "textfile"):
			$ConsoleText.scroll_text("\n")
			$ConsoleText.scroll_text("\n" + next.text + "\n")
		else:
			$ConsoleText.scroll_text("[color=red]ERROR: NON TEXT FILE[/color]\n")
	elif (command == "edit"):
		if (tokens.size() != 2):
			$ConsoleText.scroll_text("[color=red]ERROR: INVALID ARGUEMENTS[/color]\n")
			return
		var next = activeFolder.get_node(arguement)
		if (next == null):
			$ConsoleText.scroll_text("NEW FILE CREATED\n")
			next = textfile.instantiate()
			next.name = arguement
			activeFolder.add_child(next)
		if (next.get_groups()[0] == "textfile"):
			$Editor.show()
			$Editor/TextEditor.text = next.text
			$Editor.activeFile = next
			
		else:
			$ConsoleText.scroll_text("[color=red]ERROR: NON TEXT FILE[/color]\n")
	elif (command == "rm"):
		if (tokens.size() != 2):
			$ConsoleText.scroll_text("[color=red]ERROR: INVALID ARGUEMENTS[/color]\n")
			return
		var next = activeFolder.get_node(arguement)
		if (next == null):
			$ConsoleText.scroll_text("[color=red]ERROR: FILE/FOLDER NOT FOUND[/color]\n")
			return
		if ($Editor.activeFile == next):
			$Editor.activeFile = null
		next.queue_free()
	elif (command == "run"):
		if (tokens.size() != 2):
			$ConsoleText.scroll_text("[color=red]ERROR: INVALID ARGUEMENTS[/color]\n")
			return
		var next = activeFolder.get_node(arguement)
		if (next == null):
			$ConsoleText.scroll_text("[color=red]ERROR: FILE NOT FOUND[/color]\n")
			return
			
		if (next.get_groups()[0] == "textfile"):
			pass
		else:
			$ConsoleText.scroll_text("[color=red]ERROR: NON TEXT FILE[/color]\n")
	elif (command == "mkdir"):
		if (tokens.size() != 2):
			$ConsoleText.scroll_text("[color=red]ERROR: INVALID ARGUEMENTS[/color]\n")
			return
		var f = folder.instantiate()
		activeFolder.add_child(f)
		f.name = tokens[1]
	elif (command == "view"):
		if (tokens.size() != 2):
			$ConsoleText.scroll_text("[color=red]ERROR: INVALID ARGUEMENTS[/color]\n")
			return
		var next = activeFolder.get_node(arguement)
		if (next == null):
			$ConsoleText.scroll_text("[color=red]ERROR: FILE NOT FOUND[/color]\n")
			return
		if (next.get_groups()[0] == "image"):
			$ImageViewer.show()
			$ImageViewer/Title.text = "Image Viewer: " + arguement.replace("_", ".")
			$ImageViewer.setTexture(next.filepath)
		else:
			$ConsoleText.scroll_text("[color=red]ERROR: NON IMAGE FILE[/color]\n")
	else:
		$ConsoleText.scroll_text("[color=red]INVALID COMMAND: " + str(command) + "\ntype help for list of commands[/color]\n")
