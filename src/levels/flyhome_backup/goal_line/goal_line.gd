# Castle Level
var level_path = "res://src/levels/castle/castle_outside.tscn"

# If the player enters this, transition to next level
func _on_goal_line_body_enter( body ):
	print("GOAL BODYYY NAME")
	# if(body == "player"):
		#transition.fade_to(level_path) 


func _on_goal_line_area_enter( area ):
	print("GOAL ENTER AREAAAA")
	pass # replace with function body


func _on_goal_line_area_enter_shape( area_id, area, area_shape, self_shape ):
	print("NETER SHAPE!")


func _on_goal_line_body_enter_shape( body_id, body, body_shape, area_shape ):
	print("NETER SHAPE!!!!!")
