class_name Game_Window
extends Node2D

const WINDOW_BORDER_PRESS_DETECTION_WIDTH: float = 4
const WINDOW_BAR_H: float = 10

func _init(app_name: int):
	_app_name = app_name
	
	var init_x = randf_range(30, 60)
	var init_y = randf_range(30, 60)
	self.position.x = init_x
	self.position.y = init_y
	_x.set_var(init_x)
	_y.set_var(init_y)
	
	_scale.set_var(GlobalConsts.WINDOW_DEFAULT_SCALE)
	
	_set_up()
	
	_close_button = Game_Button.new((_w -  WINDOW_BAR_H - 1) * _scale.get_var(), 1 * _scale.get_var(), 
										8, 8, _scale.get_var(), 
										Color(0, 0, 0, 0))
	add_child(_close_button)
	_close_button.show_button()
	
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
	
func get_window_scale() -> float:
	return _scale.get_var()
	
func scale_transitioning() -> bool:
	return _scale.transitioning()
	
func get_app_name() -> int:
	return _app_name
	
func place_window_on_top() -> void:
	_window_list.move_child(self, _window_list.get_child_count() - 1)
	
func get_app() -> Node2D:
	return _app

@onready var _window_list: Node2D = get_node("/root/Main/WindowList")
const _texture__bar__left: Texture2D = preload("res://Assets/Sprites/UI/ui__window_bar__left.png")
const _texture__bar__right: Texture2D = preload("res://Assets/Sprites/UI/ui__window_bar__right.png")
const _texture__bar__middle: Texture2D = preload("res://Assets/Sprites/UI/ui__window_bar__middle.png")
const _texture__window__bottom_left: Texture2D = preload("res://Assets/Sprites/UI/ui__window__bottom_left.png")
const _texture__window__bottom_right: Texture2D = preload("res://Assets/Sprites/UI/ui__window__bottom_right.png")
const _texture__one_pixel_yellow: Texture2D = preload("res://Assets/Sprites/UI/ui__one_pixel_yellow.png")
const _texture__one_pixel_brown: Texture2D = preload("res://Assets/Sprites/UI/ui__one_pixel_brown.png")

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
var _min_w: float = 60
var _min_h: float = 60
var _max_w: float = 200
var _max_h: float = 200
var _scale: = SmoothVar.new(1)

var _previous_x: float = 0
var _previous_y: float = 0
var _previous_w: float = 0
var _previous_h: float = 0
var _previous_mouse_pos: Vector2

var _close_button: Game_Button

func _draw():
	draw_set_transform(Vector2(0, 0), 0, Vector2(_scale.get_var(), _scale.get_var()))

	draw_texture(_texture__bar__left, Vector2(0, 0))
	draw_texture(_texture__bar__right, Vector2(_w - 13, 0))
	draw_texture_rect(_texture__bar__middle, Rect2(3, 0, _w - 3 - 13, 10), false)
	draw_texture(_texture__window__bottom_left, Vector2(0, _h - 3))
	draw_texture(_texture__window__bottom_right, Vector2(_w - 3, _h - 3))
	draw_texture_rect(_texture__one_pixel_yellow, Rect2(0, 10, 1, _h - 10 - 3), false)
	draw_texture_rect(_texture__one_pixel_yellow, Rect2(_w - 1, 10, 1, _h - 10 - 3), false)
	draw_texture_rect(_texture__one_pixel_yellow, Rect2(3, _h - 1, _w - 3 - 3, 1), false)
	draw_texture_rect(_texture__one_pixel_brown, Rect2(1, 10, _w - 2, _h - 10 - 3), false)
	draw_texture_rect(_texture__one_pixel_brown, Rect2(3, _h - 3, _w - 6, 2), false)	
					
	if _app != null:
		_app.draw_app_content()
	
func update(delta: float) -> void:
	_close_button.update(delta)
	if _close_button.pressed():
		queue_free()
		
	if _app != null:
		_app.update(delta)
	
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
			if GlobalVars.show_debug_informations:
				print("----------------------")
				print("Window size: " + str(_w) + " " + str(_h))
				var global_mouse_pos = get_local_mouse_position()
				print("Global mouse pos: " + str(global_mouse_pos.x) + " " + str(global_mouse_pos.y))
				var local_mouse_pos = get_local_mouse_position()
				print("Local mouse pos: " + str(local_mouse_pos.x) + " " + str(local_mouse_pos.y))
			place_window_on_top()

	if _left_border_pressed:
		_x.set_var(mouse_pos.x)
		_w = (_previous_w * _scale.get_var() + (_previous_x - mouse_pos.x)) / _scale.get_var()
		if _w < _min_w:
			_w = _min_w
			_x.set_var(_previous_x + (_previous_w - _min_w) * _scale.get_var())
		if _w > _max_w:
			_w = _max_w
			_x.set_var(_previous_x + (_previous_w - _max_w) * _scale.get_var())
		_close_button.set_button_x((_w -  WINDOW_BAR_H) * _scale.get_var())
	if _right_border_pressed:
		_w = (mouse_pos.x - self.position.x) / _scale.get_var()
		if _w < _min_w:
			_w = _min_w
		if _w > _max_w:
			_w = _max_w
		_close_button.set_button_x((_w -  WINDOW_BAR_H) * _scale.get_var())
	if _top_border_pressed:
		_y.set_var(mouse_pos.y)
		_h = (_previous_h * _scale.get_var() + (_previous_y - mouse_pos.y)) / _scale.get_var()
		if _h < _min_h:
			_h = _min_h
			_y.set_var(_previous_y + (_previous_h - _min_h) * _scale.get_var())
		if _h > _max_h:
			_h = _max_h
			_y.set_var(_previous_y + (_previous_h - _max_h) * _scale.get_var())
	if _bottom_border_pressed:
		_h = (mouse_pos.y - self.position.y) / _scale.get_var()
		if _h < _min_h:
			_h = _min_h
		if _h > _max_h:
			_h = _max_h
	
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
		and mouse_pos.y <= self.position.y + _h * _scale.get_var() + WINDOW_BORDER_PRESS_DETECTION_WIDTH:
			_left_border_pressed = true
			GlobalVars.button_press_detected = true
			border_pressed = true
		
		if abs(mouse_pos.y - self.position.y) < WINDOW_BORDER_PRESS_DETECTION_WIDTH \
		and mouse_pos.x >= self.position.x - WINDOW_BORDER_PRESS_DETECTION_WIDTH \
		and mouse_pos.x <= self.position.x + _w * _scale.get_var() + WINDOW_BORDER_PRESS_DETECTION_WIDTH:
			_top_border_pressed = true
			GlobalVars.button_press_detected = true
			border_pressed = true
			
		if abs(mouse_pos.x - (self.position.x + _w * _scale.get_var())) < WINDOW_BORDER_PRESS_DETECTION_WIDTH \
		and mouse_pos.y >= self.position.y - WINDOW_BORDER_PRESS_DETECTION_WIDTH \
		and mouse_pos.y <= self.position.y + _h * _scale.get_var() + WINDOW_BORDER_PRESS_DETECTION_WIDTH:
			_right_border_pressed = true
			GlobalVars.button_press_detected = true
			border_pressed = true
			
		if abs(mouse_pos.y - (self.position.y + _h * _scale.get_var())) < WINDOW_BORDER_PRESS_DETECTION_WIDTH \
		and mouse_pos.x >= self.position.x - WINDOW_BORDER_PRESS_DETECTION_WIDTH \
		and mouse_pos.x <= self.position.x + _w * _scale.get_var() + WINDOW_BORDER_PRESS_DETECTION_WIDTH:
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
			
func _set_up() -> void:
	if _app_name == AppNames.POT:
		_app = App_Pot.new(self)
		add_child(_app)
		
		_w = 60
		_h = 80
		_min_w = 60
		_max_w = 60
		_min_h = 80
		_max_h = 80
		
	elif _app_name == AppNames.WATER:
		_app = App_Water.new(self)
		add_child(_app)
		
		_w = 60
		_h = 60
		_min_w = 60
		_max_w = 60
		_min_h = 60
		_max_h = 60
		
	elif _app_name == AppNames.VALLEY:
		_app = App_Valley.new(self)
		add_child(_app)
		
		_w = 200
		_h = 90
		_min_w = 200
		_max_w = 200
		_min_h = 90
		_max_h = 90
		
	elif _app_name == AppNames.WATERING_CAN:
		_app = App_WateringCan.new(self)
		add_child(_app)
		
		_w = 60
		_h = 60
		_min_w = 60
		_max_w = 60
		_min_h = 60
		_max_h = 60
		
	elif _app_name == AppNames.SEED:
		_app = App_Seed.new(self)
		add_child(_app)
		
		_w = 60
		_h = 60
		_min_w = 60
		_max_w = 60
		_min_h = 60
		_max_h = 60
