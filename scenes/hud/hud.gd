extends CanvasLayer

export (NodePath) var collected_text #= get_node("hudframe/items_label/score_display")
export (NodePath) var score_text #final_score_text = get_node("hudframe/finalscore_label/final_scoredisplay")
export (NodePath) var highscore_text #= get_node("hudframe/highscore_label/highscore_display")

func _ready():
	update_scores()
	game.connect("scores_changed", self, "update_scores")
	

# Update scores
func update_scores():
	get_node(collected_text).set_text(str(game.items_collected))
	get_node(score_text).set_text(str(game.score))
	get_node(highscore_text).set_text(str(game.high_score))


func _on_go_to_menu_pressed():
	transition.fade_to("res://scenes/scn1-menu/scn1.tscn")


func _on_sound_off_pressed():
	AudioServer.set_stream_global_volume_scale(0)
	pass # replace with function body
