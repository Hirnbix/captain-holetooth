extends Area2D
# Next level
var level_path = "res://src/levels/castle/castle_outside.tscn"

# On area enter
func _on_goal_line_area_enter( area ):
	# Get groups
	var groups = area.get_groups()
	
	# If the player has entered, transition to next level
	if(groups.has("player")):
		transition.fade_to(level_path)