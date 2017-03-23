
extends AnimatedSprite

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
   set_fixed_process(true)

func _fixed_process(delta):
   get_parent().set_offset(get_parent().get_offset() + (120*delta))

func gotonext():
	print("Going to next")
	transition.fade_to("res://src/screens/cutscenes/cutscene_ship_repair/cutscene_ship_repair.tscn")
