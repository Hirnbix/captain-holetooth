extends CollisionShape2D


func _on_Area2D_body_enter( body ):
		transition.fade_to("res://scenes/scn6-castle/scn6.tscn")
