class_name Game_Window
extends Node2D

const WINDOW_BORDER_WIDTH: float = 1
const WINDOW_BORDER_PRESS_DETECTION_WIDTH: float = 6
const WINDOW_MIN_W: float = 60
const WINDOW_MIN_H: float = 60
const WINDOW_BAR_H: float = 10

func _init(app_name: int, x: float, y: float, w: float, h: float, init_scale: float):
	_app_name = app_name
	self.position.x = x
	self.position.y = y
	_x.set_var(x)
	_y.set_var(y)
	_w = w
	_h = h
	_scale.set_var(init_scale)
	
	_close_button = Game_Button.new((_w -  WINDOW_BAR_H) * init_scale, 1 * init_scale, 
										9, 9, init_scale, 
										Color(1, 1, 1, 1), _texture__ui__x)
	add_child(_close_button)
	_close_button.show_button()
	
	if app_name == AppNames.POT:
		_app = App_Pot.new()
		add_child(_app)
	
func smooth_move(x: float, y: float) -> void:
	_x.set_destination(x)
	_y.set_destination(y)
	
func set_pos(x: float, y: float) -> void:
	_x.set_var(x)
	_y.set_var(y)
	
func smooth_scale(in_scale: float) -> void:
	_scale.set_destination(in_scale)
	_close_button.smooth_move((_w -  WINDOW_BAR_H) * in_scale, 1 * in_scale)
	_close_button.smooth_scale(in_scale)
	
func get_pos() -> Vector2:
	return Vector2(_x.get_var(), _y.get_var())
	
func get_destination() -> Vector2:
	return Vector2(_x.get_destination(), _y.get_destination())
	
func get_size() -> Vector2:
	return Vector2(_w, _h)
	
func get_app_name() -> int:
	return _app_name
	
func place_window_on_top() -> void:
	_window_list.move_child(self, _window_list.get_child_count() - 1)

@onready var _window_list: Node2D = get_node("/root/Main/WindowList")
const _texture__ui__x: Texture2D = preload("res://Assets/Sprites/UI/ui__x.png")

var _app_name: int = AppNames.NOT_SET

var _app: Node2D = null

var _left_border_pressed: bool = false
var _top_border_pressed: bool = false
var _right_border_pressed: bool = false
var _bottom_border_pressed: bool = false
var _bar_pressed: bool = false
var _content_pressed: bool = false

var _x: = SmoothVar.new(0)
var _y: = SmoothVar.new(0)
var _w: float = 100
var _h: float = 60
var _scale: = SmoothVar.new(1)

var _previous_x: float = 0
var _previous_y: float = 0
var _previous_w: float = 0
var _previous_h: float = 0
var _previous_mouse_pos: Vector2

var _close_button: Game_Button

func _draw():
	draw_set_transform(Vector2(0, 0), 0, Vector2(_scale.get_var(), _scale.get_var()))

	draw_rect(Rect2(WINDOW_BORDER_WIDTH/2, WINDOW_BAR_H,
					_w - WINDOW_BORDER_WIDTH/2, 
					_h - WINDOW_BAR_H),
					Color(0.79, 0.79, 0.79, 1))
	draw_rect(Rect2(0, 0, _w, WINDOW_BAR_H), Color(1, 1, 1, 1))
	draw_rect(Rect2(WINDOW_BORDER_WIDTH/2, WINDOW_BAR_H, 
					_w - WINDOW_BORDER_WIDTH, 
					_h - WINDOW_BAR_H), 
					Color(1, 1, 1, 1), false, WINDOW_BORDER_WIDTH)
	
func update(_delta: float) -> void:
	_close_button.update(_delta)
	if _close_button.pressed():
		queue_free()
	
	_border_press_check()
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	
	if Input.is_action_just_pressed("MOUSE_LEFT"):
		if _left_border_pressed or _right_border_pressed or _top_border_pressed or _bottom_border_pressed \
		or _bar_pressed:
			_previous_x = self.position.x
			_previous_y = self.position.y
			_previous_w = _w
			_previous_h = _h
			_previous_mouse_pos = mouse_pos
			place_window_on_top()
			
		if _content_pressed:
			place_window_on_top()

	if _left_border_pressed:
		_x.set_var(mouse_pos.x)
		_w = (_previous_w * _scale.get_var() + (_previous_x - mouse_pos.x)) / _scale.get_var()
		if _w < WINDOW_MIN_W:
			_w = WINDOW_MIN_W
			_x.set_var(_previous_x + (_previous_w - WINDOW_MIN_W) * _scale.get_var())
		_close_button.set_button_x((_w -  WINDOW_BAR_H) * _scale.get_var())
	if _right_border_pressed:
		_w = (mouse_pos.x - self.position.x) / _scale.get_var()
		if _w < WINDOW_MIN_W:
			_w = WINDOW_MIN_W
		_close_button.set_button_x((_w -  WINDOW_BAR_H) * _scale.get_var())
	if _top_border_pressed:
		_y.set_var(mouse_pos.y)
		_h = (_previous_h * _scale.get_var() + (_previous_y - mouse_pos.y)) / _scale.get_var()
		if _h < WINDOW_MIN_H:
			_h = WINDOW_MIN_H
			_y.set_var(_previous_y + (_previous_h - WINDOW_MIN_H) * _scale.get_var())
	if _bottom_border_pressed:
		_h = (mouse_pos.y - self.position.y) / _scale.get_var()
		if _h < WINDOW_MIN_H:
			_h = WINDOW_MIN_H
	
	if _bar_pressed:
		_x.set_var(_previous_x + mouse_pos.x - _previous_mouse_pos.x)
		_y.set_var(_previous_y + mouse_pos.y - _previous_mouse_pos.y)
		
	self.position.x = _x.get_var()
	self.position.y = _y.get_var()
		
	_close_button.redraw()
	queue_redraw()
		
func _border_press_check() -> void:
	if Input.is_action_just_released("MOUSE_LEFT"):
		_top_border_pressed = false
		_left_border_pressed = false
		_right_border_pressed = false
		_bottom_border_pressed = false
		_bar_pressed = false
		_content_pressed = false

	if GlobalVars.button_press_detected:
		return
		
	var border_pressed: bool = false
		
	if Input.is_action_just_pressed("MOUSE_LEFT"):
		var mouse_pos: Vector2 = get_global_mouse_position()
		if abs(mouse_pos.x - self.position.x) < WINDOW_BORDER_PRESS_DETECTION_WIDTH \
		and mouse_pos.y >= self.position.y - WINDOW_BORDER_PRESS_DETECTION_WIDTH \
		and mouse_pos.y <= self.position.y + (_h + WINDOW_BORDER_WIDTH) * _scale.get_var():
			_left_border_pressed = true
			GlobalVars.button_press_detected = true
			border_pressed = true
		
		if abs(mouse_pos.y - self.position.y) < WINDOW_BORDER_PRESS_DETECTION_WIDTH \
		and mouse_pos.x >= self.position.x - WINDOW_BORDER_PRESS_DETECTION_WIDTH \
		and mouse_pos.x <= self.position.x + (_w + WINDOW_BORDER_WIDTH) * _scale.get_var():
			_top_border_pressed = true
			GlobalVars.button_press_detected = true
			border_pressed = true
			
		if abs(mouse_pos.x - (self.position.x + _w * _scale.get_var())) < WINDOW_BORDER_PRESS_DETECTION_WIDTH \
		and mouse_pos.y >= self.position.y - WINDOW_BORDER_PRESS_DETECTION_WIDTH \
		and mouse_pos.y <= self.position.y + (_h + WINDOW_BORDER_WIDTH) * _scale.get_var():
			_right_border_pressed = true
			GlobalVars.button_press_detected = true
			border_pressed = true
			
		if abs(mouse_pos.y - (self.position.y + _h * _scale.get_var())) < WINDOW_BORDER_PRESS_DETECTION_WIDTH \
		and mouse_pos.x >= self.position.x - WINDOW_BORDER_PRESS_DETECTION_WIDTH \
		and mouse_pos.x <= self.position.x + (_w + WINDOW_BORDER_WIDTH) * _scale.get_var():
			_bottom_border_pressed = true
			GlobalVars.button_press_detected = true
			border_pressed = true
		
		if border_pressed: 
			return
			
		if mouse_pos.y >= self.position.y and mouse_pos.y <= self.position.y + WINDOW_BAR_H * _scale.get_var() \
		and mouse_pos.x >= self.position.x and mouse_pos.x <= self.position.x + _w * _scale.get_var():
			_bar_pressed = true
			GlobalVars.button_press_detected = true
			return
			
		if mouse_pos.x > self.position.x and mouse_pos.y > self.position.y \
		and mouse_pos.x < self.position.x + _w * _scale.get_var() \
		and mouse_pos.y < self.position.y + _h * _scale.get_var():
			_content_pressed = true
			GlobalVars.button_press_detected = true
			return
