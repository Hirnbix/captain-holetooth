extends StreamPlayer

func _enter_tree():
	# Set volume to match global every time this is instanced
	set_volume(global.music.volume)
