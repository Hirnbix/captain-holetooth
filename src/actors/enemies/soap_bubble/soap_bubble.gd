extends "res://src/actors/player/ship/flying_npc.gd"

onready var REWARD = preload("res://src/objects/rewards/reward.tscn")


# When something enters
func _on_soap_bubble_area_enter( area ):
	# Get the groups on the node involved
	var groups = area.get_groups()
	
	# If soap got hit by a player
	if(groups.has("player")):
		# Acceleration boost! Wooo!
		area.acc_boost()
		.destroy(area)
	
	# If the soap got hit by a player shot
	if(groups.has("player_shot")):
		# Spawn reward
		var reward = REWARD.instance()
		reward.set_pos(get_pos())
		get_parent().add_child(reward)
		.destroy(area)