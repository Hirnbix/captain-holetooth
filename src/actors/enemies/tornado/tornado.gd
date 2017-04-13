extends "res://src/actors/player/ship/flying_npc.gd"

# Reward Scene
onready var REWARD = preload("res://src/objects/rewards/reward.tscn")

# Health
export var health = 3

# Damage taken
var damage = 0

# When something enters
func _on_tornado_area_enter( area ):
	# Get the groups on the node involved
	var groups = area.get_groups()
	
	# If tornado got hit by a player
	if(groups.has("player")):
		# Give speed boost
		area.speed_boost()
		.destroy(area)
	
	# If the tornado got hit by a player shot
	if(groups.has("player_shot")):
		damage += 1 # increment
		
		# Spawn reward if damage exceeds health
		# This is to reduce chance of accidentically shooting the tornado; Thus make it harder to give the player the option to do so.
		if(damage > health):
			var reward = REWARD.instance()
			reward.set_name(get_name() + "_reward")
			reward.set_pos(get_pos())
			get_parent().get_parent().add_child(reward)
			.destroy(area)