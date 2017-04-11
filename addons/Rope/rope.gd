tool
extends Node2D

export(Curve2D) var Curve = null setget set_curve
export(float, 0, 1000000, 0.1) var Bake_Interval = 5 setget set_bake_interval
export(bool) var Use_Texture = false setget set_use_texture
export(Texture) var Rope_Texture = null setget set_texture
export(Color, RGBA) var Rope_Color = Color(1, 1, 1, 1) setget set_color
export(float, 0, 1000, 0.1) var Width = 1 setget set_width
export(float, 0, 100, 0.01) var Softness = 1
export(float, 0, 100, 0.01) var Mass = 0.1
export(float, 0, 100, 0.01) var Bounce = 1
export(bool) var Can_sleep = true
export(float, 0, 100, 0.1) var Linear_dumping = -1
export(float, 0, 100, 0.1) var Angular_dumping = -1

export var pined_points = [0]

var rigid_bodies = []

var uvs = Vector2Array([Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1)])

func set_use_texture(value):
    Use_Texture = value
    update()

func set_width(value):
    Width = value
    update()

func set_curve(value):
    Curve = value
    pined_points = [0]
    update()

func get_curve():
	return Curve

func set_bake_interval(value):
    Bake_Interval = value;
    Curve.set_bake_interval(Bake_Interval)
    update()

func set_texture(value):
    Rope_Texture = value
    update()

func set_color(value):
    Rope_Color = value
    update()

func get_baked_points():
    return Curve.get_baked_points()

func get_baked_length():
    return Curve.get_baked_length()

func get_point_count():
    return Curve.get_point_count()

func add_point(pos, in_pos, out_pos, index):
    Curve.add_point(pos, in_pos, out_pos, index)
    for i in range(pined_points.size()):
        if(pined_points[i] >= index):
            pined_points[i] = pined_points[i] + 1


func remove_point(index):
    Curve.remove_point(index)
    pined_points.erase(index)
    for i in range(pined_points.size()):
        if(pined_points[i] >= index):
            pined_points[i] = pined_points[i] - 1

func set_point_pos(index, pos):
    Curve.set_point_pos(index, pos)

func set_point_in(index, pos):
    Curve.set_point_in(index, pos)

func set_point_out(index, pos):
    Curve.set_point_out(index, pos)

func get_point_pos(index):
    return Curve.get_point_pos(index)

func get_point_in(index):
    return Curve.get_point_in(index)

func get_point_out(index):
    return Curve.get_point_out(index)

func _enter_tree(value):
    pass

func add_pin_point(index):
    if(!is_point_pined(index)):
        pined_points.push_back(index)

func remove_pin_point(index):
    pined_points.erase(index)

func is_point_pined(index):
    return pined_points.has(index)

func _ready():
    if(Curve == null):
        Curve = load("addons/Rope/Curve_default.tres")
        Curve = Curve.duplicate()
    Curve.connect("changed", self, "update")

    if(!get_tree().is_editor_hint()):
        ingame_ready()

func ingame_ready():
    var array = Curve.get_baked_points()
    var pined_baked_points = get_baked_pin_points()
    for i in range(0, array.size() - 1):
        var current = array[i]
        var next = array[i + 1]
        var body = RigidBody2D.new()
        var shape = RectangleShape2D.new()
        shape.set_extents(Vector2(Width / 2, (next - current).length() * 0.9))
        body.add_shape(shape)
        body.set_rot((next - current).angle())
        set_body_params(body)
        body.set_pos(current)
        add_child(body)
        if(rigid_bodies.size() > 0):
            var lastBody = rigid_bodies[rigid_bodies.size() - 1]
            add_pin_joint(lastBody.get_path(), body.get_path(), body.get_pos())

        if(pined_baked_points.has(i)):
            add_pin_joint(self.get_path(), body.get_path(), body.get_pos())
        rigid_bodies.push_back(body)

    if(pined_baked_points.has(array.size() - 1)):
        var body = rigid_bodies[rigid_bodies.size() - 1]
        var pos = get_end_pos(body)
        add_pin_joint(self.get_path(), body.get_path(), pos)
    set_process(true)

func set_body_params(body):
    body.set_mass(Mass)
    body.set_bounce(Bounce)
    body.set_can_sleep(Can_sleep)
    body.set_linear_damp(Linear_dumping)
    body.set_angular_damp(Angular_dumping)

func add_pin_joint(node_a, node_b, position):
    var pin = PinJoint2D.new()
    pin.set_node_a(node_a)
    pin.set_node_b(node_b)
    pin.set_pos(position)
    pin.set_softness(Softness)
    pin.set_exclude_nodes_from_collision(true)
    add_child(pin)

func get_baked_pin_points():
    var array = Curve.get_baked_points()
    var pined_baked_points = []
    for i in pined_points:
        var closest_length = (array[0] - Curve.get_point_pos(i)).length()
        var closest_index = 0;
        for j in range(1, array.size()):
            var currentLength = (array[j] - Curve.get_point_pos(i)).length()
            if(currentLength < closest_length):
                closest_length = currentLength
                closest_index = j
        pined_baked_points.push_back(closest_index)
    return pined_baked_points

func _process(delta):
    update()
    pass

func _draw():
    if(!get_tree().is_editor_hint()):
        var array = calculate_points_from_bodies(rigid_bodies)
        draw_rope(array)
    else:
        var array = calculate_points_from_points(Curve.get_baked_points())
        draw_rope(array)



func calculate_points_from_bodies(bodies):
    var array = []
    for i in range(0, bodies.size() - 1):
        var last = null
        var current = null
        var next = null

        var last_pos = null
        var current_pos = null
        var next_pos = null

        if(i > 0):
            last = bodies[i-1]
            last_pos = last.get_pos()
        current = bodies[i]
        next = bodies[i+1]

        current_pos = current.get_pos()
        next_pos = next.get_pos()


        var up = null
        var down = null

        if(last != null):
            var back_vector = (last_pos - current_pos)
            var front_vector = (next_pos - current_pos)
            var angle = rad2deg(back_vector.angle_to(front_vector))

            if(angle < 120 && angle > -120):
                down = (back_vector + front_vector).normalized() * (Width / 2)
                up = Vector2(-down.x, -down.y)
                down += current.get_pos()
                up += current.get_pos()
                if(angle < 0):
                    var tmp = up
                    up = down
                    down = tmp
            else:
                var current_vector = Vector2(0, 1).rotated(current.get_rot())
                down = get_down_pos(current.get_pos(), current_vector)
                up = get_up_pos(current.get_pos(), current_vector)
        else:
            var current_vector = Vector2(0, 1).rotated(current.get_rot())
            down = get_down_pos(current.get_pos(), current_vector)
            up = get_up_pos(current.get_pos(), current_vector)

        array.push_back({up = up, down = down})
    return array


func calculate_points_from_points(points):
    var array = []
    for i in range(0, points.size() - 1):
        var last = null
        var current = null
        var next = null

        if(i > 0):
            last = points[i-1]
        current = points[i]
        next = points[i+1]

        var up = null
        var down = null

        if(last != null):
            var back_vector = (last - current)
            var front_vector = (next - current)
            var angle = rad2deg(back_vector.angle_to(front_vector))

            if(angle < 120 && angle > -120):
                down = (back_vector + front_vector).normalized() * (Width / 2)
                up = Vector2(-down.x, -down.y)
                down += current
                up += current
                if(angle < 0):
                    var tmp = up
                    up = down
                    down = tmp
            else:
                var front_vector = (next - current)
                var angle = front_vector.angle()
                var current_vector = Vector2(0, 1).rotated(angle)
                down = get_down_pos(current, current_vector)
                up = get_up_pos(current, current_vector)
        else:
            var front_vector = (next - current)
            var angle = front_vector.angle()
            var current_vector = Vector2(0, 1).rotated(angle)
            down = get_down_pos(current, current_vector)
            up = get_up_pos(current, current_vector)

        array.push_back({up = up, down = down})
    return array

func draw_rope(array):
    for i in range(0, array.size() - 1):
        var current = array[i]
        var next = array[i + 1]
        if(Use_Texture && Rope_Texture != null):
            draw_polygon(Vector2Array([current.up, current.down, next.down, next.up]), ColorArray([Rope_Color]), uvs, Rope_Texture)
        else:
            draw_polygon(Vector2Array([current.up, current.down, next.down, next.up]), ColorArray([Rope_Color]))



func get_down_pos(body_pos, body_normal_vector):
    return body_pos + Vector2(-body_normal_vector.y, body_normal_vector.x) * Width/2

func get_up_pos(body_pos, body_normal_vector):
    return body_pos + Vector2(body_normal_vector.y, -body_normal_vector.x) * Width/2

func get_end_pos(rigid_bodie):
    var shape = rigid_bodie.get_shape(0)
    var position = Vector2(0, shape.get_extents().y)
    position = position.rotated(rigid_bodie.get_rot())
    return rigid_bodie.get_pos() + position
