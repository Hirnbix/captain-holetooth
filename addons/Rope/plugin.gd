tool
extends EditorPlugin


var is_godot21
var edited_object = null
var editor = null

var handles = []
var buttons = []
var handle_mode
var handle_index
var handle_pos

const curve_editor_script = preload("res://addons/Rope/curve_editor.gd")
const rope_script = preload("res://addons/Rope/rope.gd")

const handle_tex = preload("res://addons/Rope/handle.png")
const add_tex = preload("res://addons/Rope/add.png")
const remove_tex = preload("res://addons/Rope/remove.png")
const pin_tex = preload("res://addons/Rope/pin.jpg")


const HANDLE_NONE = 0
const HANDLE_POS = 1
const HANDLE_IN = 2
const HANDLE_OUT = 3
const BUTTON_ADD = 4
const BUTTON_REMOVE = 5
const BUTTON_PIN = 6

const COLOR_1 = Color(1, 1, 1, 1)
const COLOR_2 = Color(0.5, 0.5, 1, 1)
const COLOR_3 = Color(1, 0, 0, 1)

func _enter_tree():
    var godot_version = OS.get_engine_version()
    is_godot21 = godot_version.major == "2" && godot_version.minor == "1"
    add_custom_type("Rope", "Node2D", preload("rope.gd"), preload("icon.png"))

    handle_tex.set_flags(0)
    add_tex.set_flags(0)
    remove_tex.set_flags(0)


func _exit_tree():
    make_visible(false)
    remove_custom_type("Rope")


func handles(o):
	if o.get_script() == rope_script:
		return true
	else:
		return false


func edit(o):
    edited_object = o

func make_visible(b):
	print(b)
	if b:
		if is_godot21:
			if editor == null:
				var viewport = edited_object.get_viewport()
				editor = curve_editor_script.new()
				editor.plugin = self
				viewport.add_child(editor)
				viewport.connect("size_changed", editor, "update")
		update()
	else:
		if editor != null:
			editor.queue_free()
			editor = null


func int_coord(p):
	return Vector2(round(p.x), round(p.y))

func update():
	if is_godot21:
		editor.update()
	else:
		update_canvas()

func forward_draw_over_canvas(canvas_xform, canvas):
    var transform = canvas_xform * edited_object.get_global_transform()
    var pointsCount = edited_object.get_point_count()
    handles = []
    buttons = []

    for i in range(pointsCount):
        var p  = transform.xform(edited_object.get_point_pos(i))
        var p_in  = p + transform.basis_xform(edited_object.get_point_in(i))
        var p_out  = p + transform.basis_xform(edited_object.get_point_out(i))
        if(i > 0):
            canvas.draw_line(p, p_in, COLOR_2)
            canvas.draw_texture_rect(handle_tex, Rect2(int_coord(p_in) - Vector2(5, 5), Vector2(11, 11)), false)
            handles.append({ pos = p_in, mode = HANDLE_IN, index = i })
        if(i < pointsCount - 1):
            canvas.draw_texture_rect(handle_tex, Rect2(int_coord(p_out) - Vector2(5, 5), Vector2(11, 11)), false)
            canvas.draw_line(p, p_out, COLOR_2)
            handles.append({ pos = p_out, mode = HANDLE_OUT, index = i })

        canvas.draw_texture_rect(handle_tex, Rect2(int_coord(p) - Vector2(5, 5), Vector2(11, 11)), false)
        handles.append({ pos = p, mode = HANDLE_POS, index = i })

        var pin_button_color = Color(1, 1, 1)
        if(edited_object.is_point_pined(i)):
            pin_button_color = Color(1, 0.5, 0.5)
        var pin_button_rect = Rect2(int_coord(p) + Vector2(-5, -5) - pin_tex.get_size(), pin_tex.get_size())
        canvas.draw_texture_rect(pin_tex, pin_button_rect, false, pin_button_color)
        buttons.append({rect = pin_button_rect, type = BUTTON_PIN, index = i})

        if(i < pointsCount - 1):
            var p_mid = transform.xform(0.5 * (edited_object.get_point_pos(i) + edited_object.get_point_pos(i+1)) + 0.375 * (edited_object.get_point_out(i) + edited_object.get_point_in(i+1)))
            var button_rect = Rect2(int_coord(p_mid), add_tex.get_size())
            canvas.draw_texture_rect(add_tex, button_rect, false)
            buttons.append({ rect = button_rect, type = BUTTON_ADD, index = i })
        if edited_object.get_point_count() + 1 >= 4:
            # minimum number of points is 3 for closed curves and 2 for others
            var button_rect = Rect2(int_coord(p) + Vector2(5, 5), remove_tex.get_size())
            canvas.draw_texture_rect(remove_tex, button_rect, false)
            buttons.append({ rect = button_rect, type = BUTTON_REMOVE, index = i })

func forward_canvas_input_event(canvas_xform, event):
    if event.type == InputEvent.MOUSE_BUTTON:
        if event.button_index == BUTTON_LEFT:
            if event.is_pressed():
                for b in buttons:
                    if b.rect.has_point(event.pos):
                        if b.type == BUTTON_ADD:
                            # Clicked on an "add" button
                            var p_0 = edited_object.get_point_pos(b.index)
                            var p_3 = edited_object.get_point_pos(b.index+1)
                            var p_1 = p_0 + edited_object.get_point_out(b.index)
                            var p_2 = p_3 + edited_object.get_point_in(b.index+1)
                            var p_1_2 = 0.5*(p_1+p_2)
                            var p_01_12 = 0.5*p_1_2 + 0.25*(p_0 + p_1)
                            var p_12_23 = 0.5*p_1_2 + 0.25*(p_2 + p_3)
                            var p_new = 0.5*(p_01_12 + p_12_23)
                            var undoredo = get_undo_redo()
                            undoredo.create_action("Add Rope control point")
                            undoredo.add_do_method(edited_object, "add_point", p_new, p_01_12 - p_new, p_12_23 - p_new, b.index+1)
                            undoredo.add_do_method(edited_object, "set_point_out", b.index, 0.5 * edited_object.get_point_out(b.index))
                            undoredo.add_do_method(edited_object, "set_point_in", b.index+2, 0.5 * edited_object.get_point_in(b.index+2))
                            undoredo.add_undo_method(edited_object, "remove_point", b.index+1)
                            undoredo.add_undo_method(edited_object, "set_point_out", b.index, edited_object.get_point_out(b.index))
                            undoredo.add_undo_method(edited_object, "set_point_in", b.index+1, edited_object.get_point_in(b.index+1))
                            undoredo.commit_action()
                        elif b.type == BUTTON_REMOVE:
                            # Clicked on a "remove" button
                            var undoredo = get_undo_redo()
                            undoredo.create_action("Remove Rope control point")
                            undoredo.add_do_method(edited_object, "remove_pin_point", b.index)
                            undoredo.add_undo_method(edited_object, "add_pin_point", b.index)
                            undoredo.add_do_method(edited_object, "remove_point", b.index)
                            undoredo.add_undo_method(edited_object, "add_point", edited_object.get_point_pos(b.index), edited_object.get_point_in(b.index), edited_object.get_point_out(b.index), b.index)
                            undoredo.commit_action()
                        elif b.type == BUTTON_PIN:
                            if(edited_object.is_point_pined(b.index)):
                                var undoredo = get_undo_redo()
                                undoredo.create_action("Remove Rope pin point")
                                undoredo.add_do_method(edited_object, "remove_pin_point", b.index)
                                undoredo.add_undo_method(edited_object, "add_pin_point", b.index)
                                undoredo.commit_action()
                            else:
                                var undoredo = get_undo_redo()
                                undoredo.create_action("Add Rope pin point")
                                undoredo.add_do_method(edited_object, "add_pin_point", b.index)
                                undoredo.add_undo_method(edited_object, "remove_pin_point", b.index)
                                undoredo.commit_action()
                        update()
                        edited_object.update()
                        return true
                for h in handles:
                    if (event.pos - h.pos).length() < 6:
                        # Activate handle
                        handle_mode = h.mode
                        handle_index = h.index
                        # Keep initial value for undo/redo
                        if handle_mode == HANDLE_POS:
                            handle_pos = edited_object.get_point_pos(handle_index)
                        elif handle_mode == HANDLE_IN:
                            handle_pos = edited_object.get_point_in(handle_index)
                        elif handle_mode == HANDLE_OUT:
                            handle_pos = edited_object.get_point_out(handle_index)
                        update()
                        return true
            elif handle_mode != HANDLE_NONE:
                var i = edited_object.get_point_count() - 1
                var undoredo = get_undo_redo()
                undoredo.create_action("Move Rope control point")
                if handle_mode == HANDLE_POS:
                    undoredo.add_do_method(edited_object, "set_point_pos", handle_index, edited_object.get_point_pos(handle_index))
                    undoredo.add_undo_method(edited_object, "set_point_pos", handle_index, handle_pos)
                elif handle_mode == HANDLE_IN:
                        undoredo.add_do_method(edited_object, "set_point_in", handle_index, edited_object.get_point_in(handle_index))
                        undoredo.add_undo_method(edited_object, "set_point_in", handle_index, handle_pos)
                elif handle_mode == HANDLE_OUT:
                    undoredo.add_do_method(edited_object, "set_point_out", handle_index, edited_object.get_point_out(handle_index))
                    undoredo.add_undo_method(edited_object, "set_point_out", handle_index, handle_pos)
                undoredo.commit_action()
                handle_mode = HANDLE_NONE
                return true
    elif event.type == InputEvent.MOUSE_MOTION && handle_mode != HANDLE_NONE:
        var transform_inv = edited_object.get_global_transform().affine_inverse()
        var viewport_transform_inv = edited_object.get_viewport().get_global_canvas_transform().affine_inverse()
        var p = transform_inv.xform(viewport_transform_inv.xform(event.pos))
        if handle_mode == HANDLE_POS:
            edited_object.set_point_pos(handle_index, p)
        elif handle_mode == HANDLE_IN:
            edited_object.set_point_in(handle_index, p-edited_object.get_point_pos(handle_index))
        elif handle_mode == HANDLE_OUT:
            edited_object.set_point_out(handle_index, p-edited_object.get_point_pos(handle_index))
        update()
        edited_object.update()
        return true
    update()


# Godot 2.1
func forward_input_event(event):
    if editor == null:
        return false
    return forward_canvas_input_event(editor.get_viewport().get_global_canvas_transform(), event)
