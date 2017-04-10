extends Control

func _ready():
	pass

func _on_TextureButton_pressed():
	print("Debug: Jumping to Menu")
	transition.fade_to("res://src/screens/menu/menu.tscn")