extends Area2D

##################
# Ship wing
##################

onready var animation = get_node("anim")
var checkinventory = global.player_inventory.find("Ship Wing")

func _ready():
	print(global.player_inventory)
	print(checkinventory)
	if checkinventory > 0:
		self.hide()
	set_process_input(true)


func _on_Area2D_body_enter( body ):
	var groups = body.get_groups()
	if groups.has("player") && checkinventory < 0:
			#animation.play("soap_pop")
			print("touched wing")
			global.manage_inv("pickup", "Ship Wing")
			animation.play("picked_up")
			print(global.player_inventory)
			checkinventory +=1
