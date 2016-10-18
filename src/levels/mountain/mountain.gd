extends Node2D

# -- START --
func _ready():
	# Adds this scene to db
	game.open_scene("scn4")
	
	# Get initial player spawn position
	var initial_pos_player = get_node("/root/scn4/world/initial_spawn_player").get_global_pos()
	
	# Set player position
	get_node("/root/scn4/world/tile_map/player").set_global_pos(initial_pos_player)