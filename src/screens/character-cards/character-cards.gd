extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var anim = get_node("AnimationPlayer")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_TextureButton_pressed():
	print("Debug: Jumping to Menu")
	transition.fade_to("res://src/screens/menu/menu.tscn")


func _on_card_button_pressed():
 	anim.play("flip_card")
