class_name Game_Button
extends Node2D

const DOUBLE_CLICK_TIME = 600

func _init(x: float, y: float, w: float, h: float, init_scale: float, color: 
			Color = Color(1, 1, 1, 1), texture: Texture2D = null):
	self.position.x = x
	self.position.y = y
	_x.set_var(x)
	_y.set_var(y)
	_w = w
	_h = h
	_scale.set_var(init_scale)
	
	_color = color
	_texture = texture

func show_button() -> void:
	_button_visible = true
	
func hide_button() -> void:
	_button_visible = false

func pressed() -> bool:
	return _pressed

func just_pressed() -> bool:
	return _just_pressed
	
func double_clicked() -> bool:
	return _double_clicked
	
func smooth_move(x: float, y: float) -> void:
	_x.set_destination(x)
	_y.set_destination(y)
	
func transitioning_pos() -> bool:
	return _x.transitioning() or _y.transitioning()
	
func smooth_scale(in_scale: float) -> void:
	_scale.set_destination(in_scale)
	
func set_button_scale(in_scale: float) -> void:
	_scale.set_var(in_scale)
	
func set_button_x(x: float) -> void:
	_x.set_var(x)
	
func set_button_y(y: float) -> void:
	_y.set_var(y)
	
func set_button_pos(x: float, y: float) -> void:
	_x.set_var(x)
	_y.set_var(y)
	
func get_button_pos() -> Vector2:
	return Vector2(_x.get_var(), _y.get_var())
	
func get_button_destination() -> Vector2:
	return Vector2(_x.get_destination(), _y.get_destination())
	
func get_button_size() -> Vector2:
	return Vector2(_w, _h)
	
func set_button_size(w: float, h: float) -> void:
	_w = w
	_h = h
	
func mouse_drag_x() -> void:
	if _just_pressed:
		_previous_mouse_pos = get_global_mouse_position()
		_previous_x = _x.get_var()
	elif _pressed:
		var mouse_pos = get_global_mouse_position()
		_x.set_var(_previous_x + mouse_pos.x - _previous_mouse_pos.x)
		
func mouse_drag_y() -> void:
	if _just_pressed:
		_previous_mouse_pos = get_global_mouse_position()
		_previous_y = _y.get_var()
	elif _pressed:
		var mouse_pos = get_global_mouse_position()
		_y.set_var(_previous_y + mouse_pos.y - _previous_mouse_pos.y)
		
func cap_x(min_cap: float, max_cap: float) -> void:
	if _x.get_var() < min_cap:
		_x.set_var(min_cap) 
	elif _x.get_var() + _w > max_cap:
		_x.set_var(max_cap - _w)
		
func cap_y(min_cap: float, max_cap: float) -> void:
	if _y.get_var() < min_cap:
		_y.set_var(min_cap) 
	elif _y.get_var() + _h > max_cap:
		_y.set_var(max_cap - _h)
		
func redraw() -> void:
	self.position.x = _x.get_var()
	self.position.y = _y.get_var()
	queue_redraw()
		
var _button_visible: bool = false

var _x: = SmoothVar.new(0)
var _y: = SmoothVar.new(0)
var _w: float = 0
var _h: float = 0
var _scale: = SmoothVar.new(1)

var _pressed: bool = false
var _just_pressed: bool = false
var _double_clicked: bool = false

var _just_clicked_at: float = 0

var _color: Color
var _texture: Texture2D = null

var _previous_x: float = 0
var _previous_y: float = 0
var _previous_mouse_pos: Vector2
	
func _draw():
	if not _button_visible:
		return
		
	draw_set_transform(Vector2(0, 0), 0, Vector2(_scale.get_var(), _scale.get_var()))

	if _texture != null:
		draw_texture(_texture, Vector2(0, 0))
	else:
		draw_rect(Rect2(0, 0, _w, _h), _color)
	
func update(_delta) -> void:
	if not _button_visible:
		return
		
	self.position.x = _x.get_var()
	self.position.y = _y.get_var()
	
	if Input.is_action_just_released("MOUSE_LEFT"):
		_pressed = false
		
	_just_pressed = false
	_double_clicked = false
		
	if GlobalVars.button_press_detected:
		return
		
	if Input.is_action_just_pressed("MOUSE_LEFT"):
		var local_mouse_pos: Vector2 = get_local_mouse_position()
		if local_mouse_pos.x >= 0 and local_mouse_pos.y >= 0 \
		and local_mouse_pos.x <= _w * _scale.get_var() \
		and local_mouse_pos.y <= _h * _scale.get_var():
			_pressed = true
			_just_pressed = true
			if not _double_clicked and Time.get_ticks_msec() - _just_clicked_at < DOUBLE_CLICK_TIME:
				_double_clicked = true
				_just_clicked_at = 0
			else:
				_just_clicked_at = Time.get_ticks_msec()
			GlobalVars.button_press_detected = true
			
	queue_redraw()
