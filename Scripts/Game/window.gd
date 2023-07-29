class_name Game_Window
extends Node2D

const WINDOW_BORDER_PRESS_DETECTION_WIDTH: float = 4
const WINDOW_BAR_H: float = 10

func _init(app_name: int, x: float = 0, y: float = 0, close_button_disabled: bool = false):
	_app_name = app_name
	
	_set_up()
	
	var init_x: float = 0
	var init_y: float = 0
	if x != 0 or y != 0:
		init_x = x
		init_y = y
	else:
		init_x = GlobalConsts.WINDOW_WIDTH - _w * GlobalConsts.WINDOW_DEFAULT_SCALE - randf_range(30, 60)
		init_y = randf_range(30, 60)
	self.position.x = init_x
	self.position.y = init_y
	_x.set_var(init_x)
	_y.set_var(init_y)
	
	_scale.set_var(GlobalConsts.WINDOW_DEFAULT_SCALE)
	
	_close_button = Game_Button.new((_w -  WINDOW_BAR_H - 1) * _scale.get_var(), 1 * _scale.get_var(), 
										8, 8, _scale.get_var(), 
										Color(0, 0, 0, 0))
	add_child(_close_button)
	if not close_button_disabled:
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
	
func just_drag_released() -> bool:
	return Input.is_action_just_released("MOUSE_LEFT") and _bar_pressed

@onready var _window_list: Node2D = get_node("/root/Main/WindowList")
@onready var _hidden_window_list: Node2D = get_node("/root/Main/HiddenWindowList")
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

var bar_released_at: float = 0

var _left_border_hovered: bool = false
var _top_border_hovered: bool = false
var _right_border_hovered: bool = false
var _bottom_border_hovered: bool = false
var _window_hovered: bool = false

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
	if not _close_button._button_visible:
		draw_texture_rect(_texture__one_pixel_brown, Rect2(_w - 13, 2, 10, 6), false)
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
	if _close_button.just_pressed():
		if AppNames.single_window_list[_app_name]:
			_window_list.remove_child(self)
			_hidden_window_list.add_child(self)
		else:
			queue_free()
		
	if _app != null:
		_app.update(delta)
	
	_hover_check()
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
	
	_change_cursor_shape()
	
	queue_redraw()
	
func _hover_check() -> void:
	_window_hovered = false
	_left_border_hovered = false
	_top_border_hovered = false
	_right_border_hovered = false
	_bottom_border_hovered = false
	
	if GlobalVars.window_hover_detected:
		return
	
	var mouse_pos: Vector2 = get_global_mouse_position()
	
	if mouse_pos.x > self.position.x and mouse_pos.y > self.position.y \
	and mouse_pos.x < self.position.x + _w * _scale.get_var() \
	and mouse_pos.y < self.position.y + _h * _scale.get_var():
		_window_hovered = true
	
	if abs(mouse_pos.x - self.position.x) < WINDOW_BORDER_PRESS_DETECTION_WIDTH \
	and mouse_pos.y >= self.position.y - WINDOW_BORDER_PRESS_DETECTION_WIDTH \
	and mouse_pos.y <= self.position.y + _h * _scale.get_var() + WINDOW_BORDER_PRESS_DETECTION_WIDTH:
		_left_border_hovered = true
		_window_hovered = true
	
	if abs(mouse_pos.y - self.position.y) < WINDOW_BORDER_PRESS_DETECTION_WIDTH \
	and mouse_pos.x >= self.position.x - WINDOW_BORDER_PRESS_DETECTION_WIDTH \
	and mouse_pos.x <= self.position.x + _w * _scale.get_var() + WINDOW_BORDER_PRESS_DETECTION_WIDTH:
		_top_border_hovered = true
		_window_hovered = true
		
	if abs(mouse_pos.x - (self.position.x + _w * _scale.get_var())) < WINDOW_BORDER_PRESS_DETECTION_WIDTH \
	and mouse_pos.y >= self.position.y - WINDOW_BORDER_PRESS_DETECTION_WIDTH \
	and mouse_pos.y <= self.position.y + _h * _scale.get_var() + WINDOW_BORDER_PRESS_DETECTION_WIDTH:
		_right_border_hovered = true
		_window_hovered = true
		
	if abs(mouse_pos.y - (self.position.y + _h * _scale.get_var())) < WINDOW_BORDER_PRESS_DETECTION_WIDTH \
	and mouse_pos.x >= self.position.x - WINDOW_BORDER_PRESS_DETECTION_WIDTH \
	and mouse_pos.x <= self.position.x + _w * _scale.get_var() + WINDOW_BORDER_PRESS_DETECTION_WIDTH:
		_bottom_border_hovered = true
		_window_hovered = true
		
	if _window_hovered:
		GlobalVars.window_hover_detected = true
		
func _border_press_check() -> void:
	if Input.is_action_just_released("MOUSE_LEFT"):
		if _bar_pressed:
			bar_released_at = Time.get_ticks_msec()
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
		if _left_border_hovered:
			_left_border_pressed = true
			GlobalVars.button_press_detected = true
			border_pressed = true
		
		if _top_border_hovered:
			_top_border_pressed = true
			GlobalVars.button_press_detected = true
			border_pressed = true
			
		if _right_border_hovered:
			_right_border_pressed = true
			GlobalVars.button_press_detected = true
			border_pressed = true
			
		if _bottom_border_hovered:
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
		
	elif _app_name == AppNames.WATER:
		_app = App_Water.new(self)
		add_child(_app)
		
	elif _app_name == AppNames.VALLEY:
		_app = App_Valley.new(self)
		add_child(_app)
		
	elif _app_name == AppNames.WATERING_CAN:
		_app = App_WateringCan.new(self)
		add_child(_app)
		
	elif _app_name == AppNames.SEED:
		_app = App_Seed.new(self)
		add_child(_app)
		
	elif _app_name == AppNames.GARDEN:
		_app = App_Garden.new(self)
		add_child(_app)
		
	elif _app_name == AppNames.SHIP:
		_app = App_Ship.new(self)
		add_child(_app)
		
	elif _app_name == AppNames.CROW:
		_app = App_Crow.new(self)
		add_child(_app)
		
	elif _app_name == AppNames.STATS:
		_app = App_Stats.new(self)
		add_child(_app)
		
	elif _app_name == AppNames.STORE:
		_app = App_Store.new(self)
		add_child(_app)
		
	elif _app_name == AppNames.TASKS:
		_app = App_Tasks.new(self)
		add_child(_app)
		
func _change_cursor_shape() -> void:
	if ShowAllWindows._app_opening:
		return
		
	if not _window_hovered:
		return
		
	if _min_w != _max_w and _min_h != _max_h:
		if (_left_border_hovered and _top_border_hovered) \
		or (_right_border_hovered and _bottom_border_hovered):
			GlobalVars.decided_cursor_shape = GlobalVars.CursorShape.DOWNWARD_DIAGONAL
			return

		if (_right_border_hovered and _top_border_hovered) \
		or (_left_border_hovered and _bottom_border_hovered):
			GlobalVars.decided_cursor_shape = GlobalVars.CursorShape.FORWARD_DIAGONAL		
			return

	if _min_h != _max_h and (_top_border_hovered or _bottom_border_hovered):
		GlobalVars.decided_cursor_shape = GlobalVars.CursorShape.TOP_DOWN		
		return

	if _min_w != _max_w and (_left_border_hovered or _right_border_hovered):
		GlobalVars.decided_cursor_shape = GlobalVars.CursorShape.LEFT_RIGHT		
		return
		
	GlobalVars.decided_cursor_shape = GlobalVars.CursorShape.POINTER
