tool
extends WindowDialog


var msg = ""

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	get_node("Label").set_text(msg)
	set_title("Info")
	popup_centered()
	print("message ready func")

func _on_Timer_timeout():
	hide()
	queue_free()
