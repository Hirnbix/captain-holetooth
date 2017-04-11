extends Node2D

# animation Node
onready var anim = get_node("AnimationPlayer")

# Get node
export (NodePath) var button_path
onready var button = get_node(button_path)

# Start
func _ready():
	
	# Create connetion for TOGGLE
	button.connect("toggled", self, "on_toggled")
	
	# Create connection for normal button
	button.connect("pressed", self, "on_pressed")
	
	# Set button name
	
	# Set toggle mode
	button.set_toggle_mode(true)
	
	# Disable button
	#button.set_disabled(true)


# On button toggle
func on_toggled(pressed):
	if(pressed):
		print("Front")

	else:
		print("Back")
		anim.play_backwards("flip_card")

# On button pressed
func on_pressed():
	anim.play("flip_card")
