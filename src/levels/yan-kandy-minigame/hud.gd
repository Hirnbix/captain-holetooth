
extends CanvasLayer

# member variables here, example:
# var a=2
# var b="textvar"
func _process(delta):
	get_node("scoring/score_text").set_text(str(global.score_total))
	get_node("scoring/multiplier_text").set_text(str(global.score_multiplier))

func _ready():
	set_process(true)
	# Called every time the node is added to the scene.
	# Initialization here
	pass


