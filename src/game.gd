extends Node

signal scores_changed

# Game prefs
const SAVE = "user://savegame.json"
const MAX_SCORE_PER_ITEM = 0 # 0 is infinity
const MAX_ITEMS = 120

# HUD and scoring
var score = 0
var score_per_item = 1
var high_score = 0
var items_collected = 0

# Scene related
var currentScene = null
var opened_scenes = []

var db = {}

func _enter_tree():
	set_process_input(true)
	load_game()
	
func _input(e):
	if e.is_action_pressed("reload") && global.debug_mode:
		score = 0
		if db.size():
			db = {"high_score":db["high_score"]} # save only high_score on reload
		else:
			db = {"high_score": 0}
		save_game()
		load_game()
		emit_signal("scores_changed")
		get_tree().reload_current_scene()

func _exit_tree():
	save_game()

func save_key(key, value):
	db[key] = value

func load_key(key, default=null):
	if db.has(key):
		return db[key]
	else:
		return default
	
func load_game():
	var save = File.new()
	if !save.file_exists(SAVE):
		print("No saved game found")
		return

	var err = save.open(SAVE,File.READ)
	if (err):
		print("Error opening save file: " + str(err))
		return
	
	var text = save.get_as_text()
	if text:
		db.parse_json(text)
		
	items_collected = load_key("items_collected", 0)
	high_score = load_key("high_score", 0)
	opened_scenes = load_key("opened_scenes", [])

func save_game():
	var save = File.new()
	save.open(SAVE, File.WRITE)
	save.store_string(db.to_json())
	print("Game saved to " + SAVE)
	
func remove_save():
	var save = File.new()
	save.open(SAVE, File.WRITE)
	save.store_string("")
	
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		save_game()
		get_tree().quit()
		
		
func collect_item():
	items_collected += 1
	save_key("items_collected", items_collected)
	
	score += score_per_item
	if score > high_score:
		save_key("high_score", score)
		high_score = score

	emit_signal("scores_changed")
	if MAX_SCORE_PER_ITEM == 0 || score_per_item <= MAX_SCORE_PER_ITEM:
		score_per_item += 1

func reset_bonus_score():
	score_per_item = 1

func open_scene(name):
	if !is_scene_opened(name):
		opened_scenes.append(name)
		save_key("opened_scenes", opened_scenes)

func is_scene_opened(name):
	return opened_scenes.find(name) >= 0


# returns timer you can wait for, eg:
# yield(game.timer(0.5), "timeout") # wait for 0.5 sec
func timer(time):
	var t = Timer.new()
	t.set_wait_time(time)
	add_child(t)
	t.start()
	t.connect("timeout", t, "queue_free")
	return t
