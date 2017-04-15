extends "res://src/actors/player/ship/flying_npc.gd"

onready var REWARD = preload("res://src/objects/rewards/reward.tscn")
onready var animation = get_node("anim_player")
# PLAYER
# On Collision with another Body
func _on_soap_bubble_body_enter( body ):
	# Get the groups on the node involved
	var groups = body.get_groups()
	
	# If soap got hit by a player.tscn
	if(groups.has("player")):
		animation.play("soap_pop")
		global.bubbles_popped += 1
		print("popped:" + str(global.bubbles_popped))
		.destroy(body)
	
	# If the soap got hit by a player bullet.tscn
	if(groups.has("player_shot")):
		# Spawn reward
		var reward = REWARD.instance()
		reward.set_pos(get_pos())
		get_parent().add_child(reward)
		.destroy(body)


# SHIP
# On Collision with another Area
func _on_soap_bubble_area_enter( area ):
	# Get the groups on the node involved
	var groups = area.get_groups()
	global.bubbles_popped += 1
	print("popped:" + str(global.bubbles_popped))
	# If soap got hit by a player
	if(groups.has("player")):
		# Acceleration boost! Wooo!
		area.acc_boost()
		.destroy(area)
	
	# If the soap got hit by a player SHIP shot.tscn
	if(groups.has("player_shot")):
		# Spawn reward
		var reward = REWARD.instance()
		reward.set_pos(get_pos())
		get_parent().add_child(reward)
		.destroy(area)
