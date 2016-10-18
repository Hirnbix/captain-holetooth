extends TextureFrame

# Mouse click on screen to continue
func _on_skipbutton_pressed():
	# Transition to Scene 3 (Forest)
	transition.fade_to("res://src/levels/forest/forest.tscn")
