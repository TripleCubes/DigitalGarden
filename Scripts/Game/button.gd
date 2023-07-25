class_name Game_Button
extends Node2D

const DOUBLE_CLICK_TIME = 600

func pressed() -> bool:
	return _pressed

func just_pressed() -> bool:
	return _just_pressed
	
func double_clicked() -> bool:
	return _double_clicked
	
func smooth_move(x: float, y: float) -> void:
	_x.set_destination(x)
	_y.set_destination(y)
	
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
	
func set_button_size(w: float, h: float) -> void:
	_w = w
	_h = h

var _x: = SmoothVar.new(0)
var _y: = SmoothVar.new(0)
var _w: float = 0
var _h: float = 0
var _scale: = SmoothVar.new(1)

var _pressed: bool = false
var _just_pressed: bool = false
var _double_clicked: bool = false

var _just_clicked_at: float = 0

var _texture: Texture2D = null

func _init(x: float, y: float, w: float, h: float, init_scale: float, texture: Texture2D = null):
	self.position.x = x
	self.position.y = y
	_x.set_var(x)
	_y.set_var(y)
	_w = w
	_h = h
	_scale.set_var(init_scale)
	_texture = texture
	
func _draw():
	draw_set_transform(Vector2(0, 0), 0, Vector2(_scale.get_var(), _scale.get_var()))

	if _texture != null:
		draw_texture(_texture, Vector2(0, 0))
	else:
		draw_rect(Rect2(0, 0, _w, _h), Color(1, 1, 1, 1))
	
func update() -> void:
	self.position.x = _x.get_var()
	self.position.y = _y.get_var()
	
	if Input.is_action_just_released("mouse_left"):
		_pressed = false
		
	_just_pressed = false
	_double_clicked = false
		
	if GlobalVars.button_press_detected:
		return
		
	if Input.is_action_just_pressed("mouse_left"):
		var mouse_pos: Vector2 = get_global_mouse_position()
		if mouse_pos.x >= self.position.x and mouse_pos.y >= self.position.y \
		and mouse_pos.x <= self.position.x + _w * _scale.get_var() \
		and mouse_pos.y <= self.position.y + _h * _scale.get_var():
			_pressed = true
			_just_pressed = true
			if not _double_clicked and Time.get_ticks_msec() - _just_clicked_at < DOUBLE_CLICK_TIME:
				_double_clicked = true
				_just_clicked_at = 0
			else:
				_just_clicked_at = Time.get_ticks_msec()
			GlobalVars.button_press_detected = true
