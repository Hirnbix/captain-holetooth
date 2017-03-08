
extends Area2D

# member variables here, example:
# var a=2
# var b="textvar"

var dialog_yan = [
["Person A", "Hello/d050.../d005/bworld!"],
["Person B", "This is some sort of /wdialogue/r!"],
"I think I can get it to draw a /slimited/r amount of characters if I wanted to.",
"/d050.../d005/wI think I will get to it/d100 /d002some other time.",
["Person A", "Okay, that is all."] ]

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	get_node("yan_talkbox").hide()
	pass

func _on_Yan_body_enter( body ):
	if body.get_name() == "player":
		print("ENTER Yans dialogue")
		get_node("yan_talkbox").show()
		dialog.run_dialog(dialog_yan)
		print(dialog_yan)
		pass # replace with function body

func _on_Yan_body_exit( body ):
	if body.get_name() == "player":
		print("EXIT Yans dialogue")
		get_node("yan_talkbox").hide()
		pass # replace with function body