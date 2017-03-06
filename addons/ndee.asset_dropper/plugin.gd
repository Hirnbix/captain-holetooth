tool # Always declare as Tool, if it's meant to run in the editor.
extends EditorPlugin

var offset = Vector2(257,94) ### Canvas Offset due to bug
var grid_position = 1
var grid_rotation = 5

var button

### user interface variables
var ui_button
var asset_dropper_ui

var enable_scaling
var enable_rotation
var grid_size
var grid_angle
var grid_scale
var use_grid_size
var use_grid_angle
var use_grid_scale
var use_scale
var use_rotation
var asset_index_mode = "Manual"
var flip_asset = Vector2(1,1)
var draw_mode = "Drop"
var align_asset_to_stroke
var stroke_distance

var viewport
var root_node

var place_stuff = false
var place_stuff_hist = false

var resource_assets = []
var resource_asset_index = 0

var asset_scale_ratio
var asset_instance
var asset_preview
var asset_instance_init_scale = Vector2()
var asset_instance_init_rot = Vector2()

var current_asset
var draw_stroke_assets = []
var transform_stroke_assets = []

var selected_node
var target_node

var mouse_pos = Vector2()
var mouse_pos_stamp = Vector2()


var mouse_pos_os = Vector2()
var mouse_pos_os_stamp = Vector2()

var mouse_asset_offset = Vector2()

var transform_offset = Vector2(0,0)

## input varialbles
var input_handling = preload("input_handling.gd")
var mouse_l_input = input_handling.new(1,"mouse")
var mouse_r_input = input_handling.new(2,"mouse")
var key_a_input = input_handling.new(KEY_A,"key")
var key_x_input = input_handling.new(KEY_X,"key")
var key_y_input = input_handling.new(KEY_Y,"key")
var key_s_input = input_handling.new(KEY_S,"key")
var key_t_input = input_handling.new(KEY_T,"key")
var key_f_input = input_handling.new(KEY_F,"key")
var key_g_input = input_handling.new(KEY_G,"key")
var key_space_input = input_handling.new(KEY_SPACE,"key")
var key_ctrl_input = input_handling.new(KEY_CONTROL,"key")
var key_shift_input = input_handling.new(KEY_SHIFT,"key")


var mouse_apply = 0

var mouse_l
var mouse_r
var key_a
var key_x
var key_y
var key_s
var key_t
var key_f
var key_g
var key_space
var key_ctrl
var key_shift
var key_settings

var constraint_x = false
var constraint_y = false

var ui_settings = {
	"draw_mode":0,
	"asset_index_mode":0,
	"use_scale":true,
	"use_rotation":true,
	"stroke_distance":100,
	"align_asset_to_stroke":false,
	"grid_size":100,
	"grid_angle":15,
	"grid_scale":0.1,
	"use_grid_size":false,
	"use_grid_angle":false,
	"use_grid_scale":false,
}

var settings_tmp
var settings = {
	"active_group":0,
	"group_indices":[0,0,0,0,0,0,0,0,0,0],
	"ui_settings":ui_settings,
}

func get_ui_settings_from_dict():
	asset_dropper_ui.get_node("asset_draw_mode").select(settings["ui_settings"]["draw_mode"])
	asset_dropper_ui.get_node("asset_index_mode").select(settings["ui_settings"]["asset_index_mode"])
	use_scale.set_pressed(settings["ui_settings"]["use_scale"])
	use_rotation.set_pressed(settings["ui_settings"]["use_rotation"])
	stroke_distance.set_value(settings["ui_settings"]["stroke_distance"])
	align_asset_to_stroke.set_pressed(settings["ui_settings"]["align_asset_to_stroke"])
	grid_size.set_value(settings["ui_settings"]["grid_size"])
	grid_angle.set_value(settings["ui_settings"]["grid_angle"])
	grid_scale.set_value(settings["ui_settings"]["grid_scale"])
	use_grid_size.set_pressed(settings["ui_settings"]["use_grid_size"])
	use_grid_angle.set_pressed(settings["ui_settings"]["use_grid_angle"])
	use_grid_scale.set_pressed(settings["ui_settings"]["use_grid_scale"])
	
	draw_mode_select(settings["ui_settings"]["draw_mode"])
	set_asset_index_mode(settings["ui_settings"]["asset_index_mode"])
	toggle_use_grid_size(settings["ui_settings"]["use_grid_size"])
	toggle_use_grid_angle(settings["ui_settings"]["use_grid_angle"])
	toggle_use_grid_scale(settings["ui_settings"]["use_grid_scale"])
	

func write_ui_settings_to_dict():
	settings["ui_settings"]["draw_mode"] = asset_dropper_ui.get_node("asset_draw_mode").get_selected()
	settings["ui_settings"]["asset_index_mode"] = asset_dropper_ui.get_node("asset_index_mode").get_selected()
	settings["ui_settings"]["use_scale"] = use_scale.is_pressed()
	settings["ui_settings"]["use_rotation"] = use_rotation.is_pressed()
	settings["ui_settings"]["stroke_distance"] = stroke_distance.get_value()
	settings["ui_settings"]["align_asset_to_stroke"] = align_asset_to_stroke.is_pressed()
	settings["ui_settings"]["grid_size"] = grid_size.get_value()
	settings["ui_settings"]["grid_angle"] = grid_angle.get_value()
	settings["ui_settings"]["grid_scale"] = grid_scale.get_value()
	settings["ui_settings"]["use_grid_size"] = use_grid_size.is_pressed()
	settings["ui_settings"]["use_grid_angle"] = use_grid_angle.is_pressed()
	settings["ui_settings"]["use_grid_scale"] = use_grid_scale.is_pressed()
	
	
func load_settings():
	var save_file_res = File.new()
	if save_file_res.file_exists("ndee.asset_dropper.settings"):
		save_file_res.open("ndee.asset_dropper.settings",File.READ)
		#settings = save_file_res.get_as_text()
		settings.parse_json(save_file_res.get_as_text())
		save_file_res.close()
		
	else:
		save_settings()
	
func save_settings():
	var save_file_res = File.new()
	save_file_res.open("ndee.asset_dropper.settings",File.WRITE)
	save_file_res.store_string(settings.to_json())
	save_file_res.close()

func show_msg_dialog(text=""):
	var script = preload("msg_dialog.gd")
	var msg_res = preload("msg_dialog.tscn")
	var msg = msg_res.instance()
	msg.set_script(script)
	msg.msg = text
	get_base_control().add_child(msg)

func get_random_asset_index():
	var length = resource_assets.size()
	randomize()
	
	if asset_index_mode == "Random":
		settings["group_indices"][settings["active_group"]] = randi()%length
	elif asset_index_mode == "Cyclic":
		settings["group_indices"][settings["active_group"]] += 1
		settings["group_indices"][settings["active_group"]] = int(settings["group_indices"][settings["active_group"]])%length
	return settings["group_indices"][settings["active_group"]]

func run_undo(node,selection):
	get_selection().clear()
	node.free()
	for node in selection:
		get_selection().add_node(node)
	asset_instance = null
	
func run_draw_undo(nodes,selection):
	get_selection().clear()
	for node in nodes:
		node.free()
	for node in selection:
		get_selection().add_node(node)
	asset_instance = null

func add_item(parent,pos,set_owner=true):
	asset_instance = resource_assets[resource_asset_index].duplicate()
	
	if parent == null:
		parent = resource_assets[resource_asset_index].get_parent()
	parent.add_child(asset_instance)
	
	if set_owner:
		asset_instance.set_owner(get_tree().get_edited_scene_root())
	current_asset = asset_instance
	
	var asset_pos = Vector2(0,0)
	if use_grid_size.is_pressed():
		asset_pos = Vector2(stepify(pos.x,grid_size.get_value()),stepify(pos.y,grid_size.get_value()))
	else:
		asset_pos = pos
	
	asset_instance.set_scale(asset_instance.get_scale() * flip_asset)
	
	var parent_offset = Vector2(0,0)
	parent_offset =  parent.get_global_transform() * parent.get_global_pos()
	asset_instance.set_global_pos(asset_pos)
	asset_instance_init_rot = asset_instance.get_rot()
	asset_instance_init_scale = asset_instance.get_scale()
	
	### remove dropped assets from groups
	for i in range(0,10):
		var group_name = "asset_drop_" + str(i)
		if asset_instance.is_in_group(group_name):
			asset_instance.remove_from_group(group_name)
	
func add_preview(parent,pos):
	if asset_preview == null and resource_asset_index <= resource_assets.size()-1:
		asset_preview = resource_assets[resource_asset_index].duplicate()
		if parent == null:
			parent = resource_assets[resource_asset_index].get_parent()
		parent.add_child(asset_preview)
			
		asset_preview.set_global_pos(pos)
		asset_preview.set_name("preview")
		asset_preview.set_scale(asset_preview.get_scale() * flip_asset)
		

func transform_asset_preview():
	if asset_preview != null:
		var asset_pos = Vector2(0,0)
		if use_grid_size.is_pressed():
			asset_pos = Vector2(stepify(mouse_pos.x,grid_size.get_value()),stepify(mouse_pos.y,grid_size.get_value()))
		else:
			asset_pos = mouse_pos
		asset_preview.set_global_pos(asset_pos)
			
func delete_preview():
	if asset_preview != null:
		asset_preview.queue_free()
		asset_preview = null
	
func print_stuff(tree):
	for item in tree.get_root().get_children():
		for item2 in item.get_children():
			
			
			if "@ItemListEditorPlugin9261" == item2.get_name():
				print(item2.get_function_list())
				
func _input(ev):
	if viewport != null:
		if ev.type == InputEvent.MOUSE_MOTION:
			#print(viewport.get_final_transform() * viewport.get_mouse_pos())
			mouse_pos = viewport.get_global_canvas_transform().affine_inverse() * (ev.pos - offset)
			mouse_pos_os = ev.pos
			#print( Vector2(stepify(mouse_pos.x,grid_position),stepify(mouse_pos.y,grid_position)))


func move_node_in_tree():
	if  Input.is_key_pressed(KEY_PAGEDOWN):
		var nodes = get_selection().get_selected_nodes()
		for node in nodes:
			if node.get_index() < node.get_parent().get_child_count()-1:
				node.get_parent().move_child(node,node.get_index()+1)
		return true
	elif  Input.is_key_pressed(KEY_PAGEUP):
		var nodes = get_selection().get_selected_nodes()
		for node in nodes:
			if node.get_index() > 0:
				node.get_parent().move_child(node,node.get_index()-1)
		return true
	else:
		return false

func get_group_asset_index():
	pass

func add_to_group():
	if key_ctrl in [1,2] or key_shift in [1,2]:
		for i in range(0,10):
			if Input.is_key_pressed(KEY_0 + i):
				var group_name = "asset_drop_" + str(i)
				if key_ctrl in [1,2]:
					if get_tree().has_group(group_name):
						for node in get_tree().get_nodes_in_group(group_name):
							node.remove_from_group(group_name)
				for node in get_selection().get_selected_nodes():
					node.add_to_group(group_name,true)
					
				resource_assets = get_tree().get_nodes_in_group(group_name)
				var msg = "Assets added to Group" + str(i)
				show_msg_dialog(msg)
				if settings["group_indices"][settings["active_group"]] > resource_assets.size()-1:
					 settings["group_indices"][settings["active_group"]] = resource_assets.size()-1
				resource_asset_index = settings["group_indices"][settings["active_group"]]
				return true
	return false
				
func set_group_as_resource_assets(assign=null):
	if key_ctrl == 0 and key_shift == 0:
		for i in range(0,10):
			if Input.is_key_pressed(KEY_0 + i) or assign != null:
				if assign != null:
					i = assign
				var group_name = "asset_drop_" + str(i)
				if get_tree().has_group(group_name):
					resource_assets = get_tree().get_nodes_in_group(group_name)
#					get_group_settings() ### get settings from user interface
					settings["active_group"] = i
#					set_group_settings() ### set user interface settings
					
					resource_asset_index = settings["group_indices"][settings["active_group"]]
					if settings["group_indices"][settings["active_group"]] > resource_assets.size()-1:
						settings["group_indices"][settings["active_group"]] = resource_assets.size()-1
					
					if asset_preview == null:
						add_preview(target_node,mouse_pos)
						var timer = Timer.new()
						add_child(timer)
						timer.connect("timeout",self,"preview_timer",[timer])
						timer.set_wait_time(0.3)
						timer.set_one_shot(true)
						timer.start()
				
				return true
	return false

func preview_timer(timer):
	delete_preview()
	timer.queue_free()

func draw_asset_behavior(forward_input):
	
	if key_a == 1:
		
		add_preview(target_node,Vector2(0,0))
		
	elif key_a == 3:
		delete_preview()
	
	var viewport_zoom = viewport.get_global_canvas_transform().get_scale()[0]
	var stroke_target_length = stroke_distance.get_value()
	if use_grid_size.is_pressed():
		stroke_target_length = grid_size.get_value()
		mouse_pos = Vector2(stepify(mouse_pos.x,grid_size.get_value()),stepify(mouse_pos.y,grid_size.get_value()))
	var stroke_vec = mouse_pos_stamp - mouse_pos
	var stroke_vec_norm = stroke_vec.normalized()
	var stroke_length = stroke_vec.length()

	### run node transformations
	for node in transform_stroke_assets:
		if align_asset_to_stroke.is_pressed():
			node.set_scale(Vector2(abs(node.get_scale().x),abs(node.get_scale().y)))
			node.look_at(mouse_pos)
			node.set_scale(Vector2(flip_asset.x * abs(node.get_scale().x),flip_asset.y * abs(node.get_scale().y)))
			if stroke_vec.x < 0:
				node.rotate(deg2rad(-90))
			else:
				node.rotate(deg2rad(90))
	
	if mouse_l == 1 and key_a in [1,2]:
		draw_stroke_assets = []
		transform_stroke_assets = []
		
		
		mouse_pos_stamp = mouse_pos
		add_item(target_node,mouse_pos,false)
		draw_stroke_assets.append(asset_instance)
		transform_stroke_assets.append(asset_instance)
		get_random_asset_index()
		

	elif mouse_l == 2 and key_a in [1,2] and stroke_length >= stroke_target_length:
		transform_stroke_assets = []
		#print(stroke_length - stroke_target_length)
		var asset_count = int(stroke_length / stroke_target_length + 0.5)
		var pos = Vector2()
		for i in range(asset_count):
			var j = asset_count - i - 1
			#pos = mouse_pos + (stroke_vec_norm * stroke_target_length * j)
			#pos = mouse_pos + (mouse_pos_stamp - mouse_pos) * j#(stroke_vec_norm * stroke_target_length * j)
			pos = mouse_pos + ((stroke_vec_norm * stroke_length / asset_count)*j)
			add_item(target_node,pos,false)
			draw_stroke_assets.append(asset_instance)
			transform_stroke_assets.append(asset_instance)
			get_random_asset_index()
			resource_asset_index = settings["group_indices"][settings["active_group"]]
			
		mouse_pos_stamp = mouse_pos
		
		
	elif mouse_l == 3 and key_a in [1,2]:
		transform_stroke_assets = []
		for node in draw_stroke_assets:
			node.set_owner(get_tree().get_edited_scene_root())
		#mouse_pos_stamp = mouse_pos
		### register undo step
		get_undo_redo().create_action("Draw Assets")
		get_undo_redo().add_undo_method(self,"run_draw_undo",draw_stroke_assets,get_selection().get_selected_nodes())
		get_undo_redo().commit_action()
		
		### reload asset preview
		delete_preview()
		add_preview(target_node,mouse_pos)
	transform_asset_preview()
		
		
	if key_a in [1,2]:
		return true
	return false	
			
func drop_asset_behavior(forward_input):
	### add asset on press
	if mouse_l == 1 and key_a in [1,2] and mouse_apply == 0:
		mouse_pos_os_stamp = Vector2(mouse_pos_os)
		mouse_pos_stamp = mouse_pos
		add_item(target_node,mouse_pos)
		
		var mouse_offset = Vector2(400,0)* resource_assets[resource_asset_index].get_scale().x * viewport.get_global_canvas_transform().get_scale().x
		Input.warp_mouse_pos(Vector2(mouse_pos_os) + mouse_offset)
		
		### set asset x y scale ratio
		asset_scale_ratio = Vector2(1,resource_assets[resource_asset_index].get_scale().y / resource_assets[resource_asset_index].get_scale().x)
		
		### register undo step
		get_undo_redo().create_action("Drop Asset")
		get_undo_redo().add_undo_method(self,"run_undo",asset_instance,get_selection().get_selected_nodes())
		get_undo_redo().commit_action()
		
		
	elif mouse_l == 3 and key_a in[1,2] and mouse_apply == 0:
		mouse_apply = 1
	
	### drag asset behavior while transforming
	if key_space == 1 and asset_instance != null:
		mouse_asset_offset = mouse_pos - mouse_pos_stamp
	if key_space == 2 and asset_instance != null:
		var pos = mouse_pos-mouse_asset_offset
		if use_grid_size.is_pressed():
			pos = Vector2(stepify(pos.x,grid_size.get_value()),stepify(pos.y,grid_size.get_value()))
		asset_instance.set_global_pos(pos)
		mouse_pos_os_stamp = Vector2(pos)
		mouse_pos_stamp = mouse_pos - mouse_asset_offset
		
	
	if key_a == 1:
		add_preview(target_node,Vector2(0,0))
		
	if key_a in[1,2]:
		if not Input.is_mouse_button_pressed(BUTTON_MIDDLE):
			forward_input = true
			
		transform_asset_preview()


		### handle axis constraint
		var new_scale = Vector2(1,1)
		if key_x == 1:
			constraint_x = !constraint_x
			constraint_y = false
		if key_y == 1:
			constraint_y = !constraint_y
			constraint_x = false
		
		### transform added asset
		if asset_instance != null:
			delete_preview()
			
			var scale = ((mouse_pos_stamp) - mouse_pos).length()
			
			var dir_vec = ((mouse_pos_stamp) - mouse_pos)
			var dir_vec_rotated = ((mouse_pos_stamp+Vector2(-2,0)) - mouse_pos).normalized().rotated(deg2rad(90))
			var rot = atan2(dir_vec_rotated.x,dir_vec_rotated.y)
			
			
			new_scale = Vector2(1,1)* scale * 0.0025
				
			### viewport.get_global_canvas_transform().get_scale() -> defines the viewport zoom
			if scale * viewport.get_global_canvas_transform().get_scale()[0] > 5.0:
				
				if use_scale.is_pressed():
					
					var final_scale = new_scale / asset_instance.get_parent().get_global_transform().get_scale() 
					if use_grid_scale.is_pressed():
						final_scale = Vector2(stepify(final_scale.x,grid_scale.get_value()),stepify(final_scale.y,grid_scale.get_value())) * asset_scale_ratio
					
#						asset_instance.set_scale(final_scale * flip_asset)
					if constraint_x:
						asset_instance.set_scale(Vector2(final_scale.x,abs(asset_instance.get_scale().y)) * flip_asset)
					elif constraint_y:
						asset_instance.set_scale(Vector2(abs(asset_instance.get_scale().x),final_scale.y) * flip_asset)
					else:
						asset_instance.set_scale(final_scale * flip_asset * asset_scale_ratio)
				
				if use_rotation.is_pressed():
					var final_rot = rot-asset_instance.get_parent().get_global_transform().get_rotation()
					if use_grid_angle.is_pressed():
						final_rot = stepify(final_rot,deg2rad(grid_angle.get_value()))
					if dir_vec.x < 0:
						asset_instance.set_rot(final_rot)
					elif dir_vec.x > 0:
						asset_instance.set_rot(final_rot + PI)
			else:
				asset_instance.set_rot(-asset_instance.get_parent().get_global_transform().get_rotation())
				asset_instance.set_scale( resource_assets[resource_asset_index].get_scale() * flip_asset * asset_scale_ratio)
		
		### apply transformation
		if mouse_l == 1 and mouse_apply == 1:
			constraint_y = false
			constraint_x = false
			
			mouse_apply = 2
			asset_instance = null
		if mouse_l == 3:
			mouse_apply = 0
			#get_selection().clear()
			#get_selection().add_node(asset_instance)
			
			asset_instance = null
			Input.warp_mouse_pos(Vector2(mouse_pos_os_stamp))
			get_random_asset_index()
			add_preview(target_node,mouse_pos_stamp)
			
			
		
		### abort transformation
		if mouse_r == 3:
			constraint_y = false
			constraint_x = false
			mouse_apply = 0
			asset_instance.set_rot(asset_instance_init_rot)
			asset_instance.set_scale(asset_instance_init_scale)
			
			var mouse_offset = Vector2(400,0)* resource_assets[resource_asset_index].get_scale().x * viewport.get_global_canvas_transform().get_scale().x
			Input.warp_mouse_pos(Vector2(mouse_pos_os_stamp) + mouse_offset)
	elif key_a == 3:
		delete_preview()
	else:
		constraint_y = false
		constraint_x = false
		mouse_apply = 0
		if asset_instance != null:
			asset_instance.queue_free()
		asset_instance = null
	
	return forward_input

func handles(object):
	return true

func open_settings_menu():
	asset_dropper_ui.hide()
	asset_dropper_ui.popup()
	var offset = asset_dropper_ui.get_size() * 0.5
	asset_dropper_ui.set_pos(mouse_pos_os - offset)
	

func scrub_through_assets():
	if Input.is_mouse_button_pressed(BUTTON_WHEEL_UP):
		settings["group_indices"][settings["active_group"]] += 1
		settings["group_indices"][settings["active_group"]] = int(settings["group_indices"][settings["active_group"]])%resource_assets.size()
		resource_asset_index = settings["group_indices"][settings["active_group"]]
		delete_preview()
		add_preview(target_node,Vector2(0,0))
		
	elif Input.is_mouse_button_pressed(BUTTON_WHEEL_DOWN):
		settings["group_indices"][settings["active_group"]] -= 1
		if settings["group_indices"][settings["active_group"]] < 0:
			settings["group_indices"][settings["active_group"]] = resource_assets.size()-1
		settings["group_indices"][settings["active_group"]] = int(settings["group_indices"][settings["active_group"]])%resource_assets.size()
		resource_asset_index = settings["group_indices"][settings["active_group"]]
		delete_preview()
		add_preview(target_node,Vector2(0,0))

func forward_input_event(event):
	
	mouse_l = mouse_l_input.check()
	mouse_r = mouse_r_input.check()
	key_a = key_a_input.check()
	key_x = key_x_input.check()
	key_y = key_y_input.check()
	key_s = key_s_input.check()
	key_t = key_t_input.check()
	key_f = key_f_input.check()
	key_g = key_g_input.check()
	key_space = key_space_input.check()
	key_ctrl = key_ctrl_input.check()
	key_shift = key_shift_input.check()
	
	resource_asset_index = settings["group_indices"][settings["active_group"]]
	
	var forward_input = false
	forward_input = forward_input or move_node_in_tree()
	forward_input = forward_input or add_to_group()
	forward_input = forward_input or set_group_as_resource_assets()

	root_node = get_tree().get_edited_scene_root()
		
	### assign resource assets and target node
	if key_ctrl == 0:
		if key_s == 1:
			open_settings_menu()
		if key_t == 1:
			set_target_node()

	if root_node != null:
		viewport = root_node.get_viewport()
		
		
		
	if root_node != null and (resource_asset_index <= resource_assets.size()-1) and resource_assets[resource_asset_index] != null and resource_assets[resource_asset_index].get_owner() != null:
		if key_a in [1,2]:
			if key_f == 1:
				flip_asset.x *= -1
				delete_preview()
				add_preview(target_node,Vector2(0,0))
			if key_g == 1:
				flip_asset.y *= -1
				delete_preview()
				add_preview(target_node,Vector2(0,0))
			
			if asset_index_mode in ["Manual","Cyclic"]:
				scrub_through_assets()
		
		### drop asset behavior -> lets you place assets and scale,rotate and reposition them via dragging
		if key_ctrl == 0:
			if draw_mode == "Drop":
				forward_input = forward_input or drop_asset_behavior(forward_input)
			elif draw_mode == "Draw":
				forward_input = forward_input or draw_asset_behavior(forward_input)
		
	
	return forward_input


func set_target_node():
	target_node = get_selection().get_selected_nodes()[0]
func clear_target_node():
	target_node = null

func open_asset_dropper_ui():
	asset_dropper_ui.popup_centered()

func set_asset_index_mode(idx):
	asset_index_mode = asset_dropper_ui.get_node("asset_index_mode").get_item_text(idx)

func draw_mode_select(idx):
	draw_mode = asset_dropper_ui.get_node("asset_draw_mode").get_item_text(idx)
	if draw_mode == "Draw":
		asset_dropper_ui.get_node("drop_mode").hide()
		asset_dropper_ui.get_node("draw_mode").show()
	elif draw_mode == "Drop":
		asset_dropper_ui.get_node("drop_mode").show()
		asset_dropper_ui.get_node("draw_mode").hide()	
		
func toggle_use_grid_size(pressed):
	stroke_distance.set_editable(!pressed)
	grid_size.set_editable(pressed)
	if pressed:
		grid_size.get_node("Label").set_opacity(1.0)
	else:
		grid_size.get_node("Label").set_opacity(.5)

func toggle_use_grid_angle(pressed):
	grid_angle.set_editable(pressed)
	if pressed:
		grid_angle.get_node("Label").set_opacity(1.0)
	else:
		grid_angle.get_node("Label").set_opacity(.5)
	
func toggle_use_grid_scale(pressed):
	grid_scale.set_editable(pressed)
	if pressed:
		grid_scale.get_node("Label").set_opacity(1.0)
	else:
		grid_scale.get_node("Label").set_opacity(.5)

func _enter_tree():
	
	print("enter tree")
	set_process_input(true)
	
	var ui_res = preload("AssetDropperUI.tscn")
	asset_dropper_ui = ui_res.instance()
	get_base_control().add_child(asset_dropper_ui)
	
	asset_dropper_ui.get_node("set_target_node").connect("pressed",self,"set_target_node")
	asset_dropper_ui.get_node("clear_target_node").connect("pressed",self,"clear_target_node")
	asset_dropper_ui.get_node("asset_index_mode").connect("item_selected",self,"set_asset_index_mode")
	asset_dropper_ui.get_node("asset_index_mode").select(2)
	asset_dropper_ui.get_node("asset_draw_mode").connect("item_selected",self,"draw_mode_select")
	
	grid_size = asset_dropper_ui.get_node("grid_size/grid")
	grid_angle = asset_dropper_ui.get_node("drop_mode/grid_angle/grid")
	grid_scale = asset_dropper_ui.get_node("drop_mode/grid_scale/grid")
	
	use_grid_size = asset_dropper_ui.get_node("grid_size/check_button")
	use_grid_angle = asset_dropper_ui.get_node("drop_mode/grid_angle/check_button")
	use_grid_scale = asset_dropper_ui.get_node("drop_mode/grid_scale/check_button")
	
	use_grid_size.connect("toggled",self,"toggle_use_grid_size")
	use_grid_angle.connect("toggled",self,"toggle_use_grid_angle")
	use_grid_scale.connect("toggled",self,"toggle_use_grid_scale")

	use_scale = asset_dropper_ui.get_node("drop_mode/use_scale")
	use_rotation = asset_dropper_ui.get_node("drop_mode/use_rotation")
	
	align_asset_to_stroke = asset_dropper_ui.get_node("draw_mode/align_asset_to_stroke")
	stroke_distance = asset_dropper_ui.get_node("draw_mode/stroke_distance")
	
	ui_button = Button.new()
	ui_button.set_name("Asset Dropper")
	ui_button.set_text("Asset Dropper")
	add_control_to_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU,ui_button)
	ui_button.connect("pressed",self,"open_asset_dropper_ui")
	load_settings()
	get_ui_settings_from_dict()
	
	
func _exit_tree():
	write_ui_settings_to_dict()
	save_settings()
	
	set_process_input(false)
	
	print("exit tree")
	if ui_button != null:
		ui_button.free()
		ui_button = null
	
	if asset_dropper_ui != null:
		asset_dropper_ui.free()
		asset_dropper_ui = null
	queue_free()
