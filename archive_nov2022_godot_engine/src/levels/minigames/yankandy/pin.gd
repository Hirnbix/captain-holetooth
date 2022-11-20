
extends RigidBody2D

# member variables here, example:
# var a=2
# var b="textvar"

var secret_pin_hit = false

export(String, "box_area1", "box_area2", "box_area3", "box_area4", "box_area5", "box_area6", "box_area7", "box_area8", "box_secret_pin") var box_area

func _ready():
	pass
	
func anim_popup_score():
	get_node("pin_score_flag/pin_score_text").set_text(str(global.yankandy_score_pins))

func _on_pin_body_enter( body ):
	var touchbody = body.get_name()
	#if body.get_name() == "ball":
	print(touchbody + " touched pin")
	global.yankandy_score_pins += 1
	global.yankandy_score_multiplier += 1
	global.yankandy_score_total += global.yankandy_score_pins * global.yankandy_score_multiplier
	get_node("score_animation").play("pin_score_anim")
	
	if box_area == "box_area1":
		get_node("sfx").play("pin_sound_1")
	
	if box_area == "box_area2":
		get_node("sfx").play("pin_sound_2")
		
	if box_area == "box_area3":
		get_node("sfx").play("pin_sound_3")
	
	if box_area == "box_area4":
		get_node("sfx").play("pin_sound_4")

	if box_area == "box_area5":
		get_node("sfx").play("pin_sound_5")

	if box_area == "box_area6":
		get_node("sfx").play("pin_sound_6")
	
	if box_area == "box_area7":
		get_node("sfx").play("pin_sound_7")

	if box_area == "box_area8":
		get_node("sfx").play("pin_sound_8")
	
	if box_area == "box_secret_pin" and secret_pin_hit == false:
		secret_pin_hit = true
		global.yankandy_score_total += 5000
		get_node("sfx").play("yan_secret_pin")
		get_node("sfx").play("bronze_bell")
		get_node("score_animation").play("secret_pin_animation")
	
	else:
		# Old code that randomized the pins, just here for future use maybe
		#randomize()
		#var pinsound_random = randi()%8+1
		#print(pinsound_random)
		#get_node("sfx").play("pin_sound_" + str(pinsound_random))
		get_node("sfx").play("tin")








