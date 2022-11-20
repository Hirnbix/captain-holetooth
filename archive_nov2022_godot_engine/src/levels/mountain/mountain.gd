extends Node2D

# -- START --
func _ready():
	# Adds this scene to db
	game.open_scene("scn4")
	var initial_pos_player
	# Get initial player spawn position
	global.last_pos[1].x += 100#adding beacause the player would spawn in the teleport
	initial_pos_player = global.last_pos[1]
	# Set player position
	get_node("/root/scn4/world/tile_map/player").set_global_pos(initial_pos_player)