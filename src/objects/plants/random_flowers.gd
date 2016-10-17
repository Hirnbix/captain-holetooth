
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

#var time = 0
#var timeout = 6000

func _ready():

#	set_process(true)
	
#func _process(delta):
#	if time >= timeout:
#		_timeout()
#	else:
#		time += 1
		
#func _timeout():
#	time = 0
	randomize()
	var random_head = randi()%4+0
	var random_body = randi()%4+0
	var random_leg = randi()%4+0
	var random_offset = randi()%10+1
	print(random_offset)
	
	get_node("head").set_frame(random_head)
	get_node("body").set_frame(random_body)
	get_node("leg").set_frame(random_leg)
	
	get_node("head").set_offset(Vector2(0, random_offset))
	get_node("body").set_offset(Vector2(0, random_offset))