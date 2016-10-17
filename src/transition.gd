
extends CanvasLayer

onready var anim = get_node("AnimationPlayer")
var fading = false

func fade_to(path):
	if fading:
		print("Skip fading to " + path)
		return
	fading = true
		
	anim.play("fade_in")
	yield(anim, "finished")
	get_tree().change_scene(path)
	anim.play("fade_out")
	
	fading = false
