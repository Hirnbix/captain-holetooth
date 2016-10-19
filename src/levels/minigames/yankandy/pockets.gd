
extends Area2D

# member variables here, example:
# var a=2
# var b="textvar"

var pocket_entered = false

func _ready():
#	get_node("../hud/score_text").set_text(str(score))
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _on_pocket1_body_enter( body ):
	if body.get_name() == "ball" && pocket_entered == false:
		print("pocket1")
		global.yankandy_score_total += 200
		pocket_entered = true
		pass # replace with function body

func _on_pocket2_body_enter( body ):
	if body.get_name() == "ball" && pocket_entered == false:
		print("pocket2")
		global.yankandy_score_total += 300
		pocket_entered = true
		pass # replace with function body


func _on_pocket3_body_enter( body ):
	if body.get_name() == "ball" && pocket_entered == false:
		print("pocket3")
		global.yankandy_score_total += 600
		pocket_entered = true
		pass # replace with function body

func _on_pocket4_body_enter( body ):
	if body.get_name() == "ball" && pocket_entered == false:
		print("pocket4-SUPER")
		global.yankandy_score_total *= 5
		get_node("../../sfx").play("bronze_bell")
		pocket_entered = true
		pass # replace with function body

