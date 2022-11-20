extends Node

const PATH = "user://savegame.json"

var db = {}
func _ready():
	set_process_input(true)
	
func _input(e):
	if e.is_action_pressed("reload") && global.debug_mode:
		global.score = 0
		db = {}
		
func _enter_tree():
	load_game()

func _exit_tree():
	save_game()

func set_key(key, value):
	db[key] = value

func get_key(key, default=null):
	if db.has(key):
		return db[key]
	else:
		return default
	
func load_game():
	var save = File.new()
	if !save.file_exists(PATH):
		print("No saved game found")
		return
	var err = save.open(PATH,File.READ)
	if (err):
		print("Error opening save file: " + str(err))
	
	var text = save.get_as_text()
	if text:
		db.parse_json(text)

func save_game():
	var save = File.new()
	save.open(PATH, File.WRITE)
	save.store_string(db.to_json())
	print("Game saved to " + PATH)
	
func remove_save():
	var save = File.new()
	save.open(PATH, File.WRITE)
	save.store_string("")
	
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		save_game()
		get_tree().quit() # default behavior
