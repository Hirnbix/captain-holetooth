
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	for scene in game.opened_scenes:
		if has_node("jump_" + scene):
			get_node("jump_" + scene).show()
			
	
func _on_jump_scn3_pressed():
	print("Going to scn3")
	transition.fade_to("res://scenes/scn3-forest/scn3.tscn")

func _on_jump_scn4_pressed():
	print("Going to scn4")
	transition.fade_to("res://scenes/scn4-mountain/scn4.tscn")

func _on_jump_scn5_pressed():
	print("Going to scn5")
	transition.fade_to("res://scenes/scn5-ship/scn5.tscn")

func _on_jump_minigame_pressed():
	print("Going to minigame")
	transition.fade_to("res://scenes/yan-kandy-minigame/prototype.tscn")
