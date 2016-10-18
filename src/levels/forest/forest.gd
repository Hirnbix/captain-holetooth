extends Node

var tele2pos

func _ready():
	
	var initial_pos_player = get_node("/root/scn3/initial_spawn_player").get_global_pos()
	var enemy_group =  get_tree().get_nodes_in_group("enemies")
	print(enemy_group)
	game.open_scene("scn3")
	get_node("/root/scn3/tile_map/player").set_pos(initial_pos_player)
	
	if game.is_scene_opened("scn4"):
		#player.beam_to("/root/scn3/teleporter/spawn_scn3")
		var tele2pos = get_node("/root/scn3/teleporter_spawn_scn3").get_global_pos()
		print(tele2pos)
		#var tele2pos = self.get_pos()
		get_node("/root/scn3/tile_map/player").set_pos(tele2pos)


		

	# Called every time the node is added to the scene.
	# Initialization here
	# print(beamnode)