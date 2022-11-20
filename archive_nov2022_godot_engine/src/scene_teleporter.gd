extends Area2D

#onready var node_path = self.get_path()
export(String, FILE, "*.tscn") var scene_path

func _ready():
	print (scene_path + ", " + get_path())
	find_node("teleporter_debug_label").set_text(scene_path)
	
func _on_scene_teleporter_body_enter( body ):
	print("Teleporting to " + scene_path)
	
	if global.player_inventory.has("Ship Wing"):
		print("You have the wing")
	else:
		print("Sorry, no wing")
	body.set_process(false)
	#find_node("teleporter_debug_label").set_text(scene_path)
	if body.get_name() == "player":
		var current = get_tree().get_current_scene().get_name()
		global.last_pos[current[current.length()-1].to_int() - 3] = body.get_global_pos()
		transition.fade_to(str(scene_path))

	#transition.fade_to("res://" + scene_path)
	#var tele1pos = get_node("/root/scn3/tele1/teleporter1").get_global_pos()
	#var tele2pos = self.get_pos()
	#get_node("/root/scn3/tile_map/player").set_pos(tele1pos)