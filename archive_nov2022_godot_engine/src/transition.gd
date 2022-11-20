
extends CanvasLayer

# Animation player for fading
onready var anim = get_node("AnimationPlayer")

# Fade controller
var fading = false

# Fade to scene path
func fade_to(path):
	# If we are currently fading to a scene, return
	if fading:
		print("DEBUG: Skip fading to " + path)
		return
	
	# Set fading to true to prevent fading while fading
	fading = true
	
	# Start fading in and out
	anim.play("fade_in")
	
	# Wait until animation is finished
	yield(anim, "finished")
	
	# Chance scene
	get_tree().change_scene(path)
	
	# Fade back out into the new scene
	anim.play("fade_out")
	
	# No longer fading, so we are ready to fade again when needed
	fading = false