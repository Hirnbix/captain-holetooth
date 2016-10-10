extends CollisionShape2D

# member variables here, example:
# var a=2
# var b="textvar"

func _on_tele2_body_enter( body ):
	transition.fade_to("res://scenes/scn4-mountain/scn4.tscn")
	#var tele1pos = get_node("/root/scn3/tele1/teleporter1").get_global_pos()
	#var tele2pos = self.get_pos()
	#get_node("/root/scn3/tile_map/player").set_pos(tele1pos)