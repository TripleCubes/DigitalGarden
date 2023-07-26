extends Node2D

const PADDING_TOP: float = 40
const GROUP_SEPARATION: float = 30
const LINE_SEPARATION: float = 20
const PADDING_BOTTOM: float = 40

const PADDING_LEFT: float = 80
const PADDING_RIGHT: float = 30
const SPACE_WIDTH: float = 10

func open_app() -> void:
	if _app_opening:
		return
		
	_scroll_bar.show_scrollbar()
	_scroll_bar.scroll_to_zero()
	
	_previous_window_pos_list.clear()
	_previous_desktop_icon_pos_list.clear()
	
	for app_group in _organized_window_list:
		app_group.clear()
	
	for window in _window_list.get_children():
		_previous_window_pos_list.append(window.get_destination())
		_organized_window_list[window.get_app_name()].append(window)
		
	for icon in _desktop_icon_list.get_children():
		_previous_desktop_icon_pos_list.append(icon.get_destination())
		
	_scroll_bar.set_page_size(_set_windows_position(0, true), 500)
		
	_app_opening = true
	
@onready var _window_list: Node2D = get_node("/root/Main/WindowList")
@onready var _desktop_icon_list: Node2D = get_node("/root/Main/Desktop")

var _scroll_bar: = Game_ScrollBar.new(800, 0, false, 500)

var _previous_window_pos_list: = []
var _previous_desktop_icon_pos_list: = []

var _organized_window_list: = []

var _cursor_y: float = 0
var _cursor_x: float = 0

var _app_opening: bool = false

func _close_app() -> void:
	if not _app_opening:
		return
		
	_scroll_bar.hide_scrollbar()
	_app_opening = false

func update(delta) -> void:
	if not _app_opening:
		return
		
	_scroll_bar.update(delta)
	if _scroll_bar.scrolled():
		_set_windows_position(_scroll_bar.get_value_pixel(), false)
		
	_window_click_check()
	
func _ready():
	_organized_window_list.clear()
	for i in AppNames.NUMBER_OF_NAMES:
		_organized_window_list.append([])
		
	get_node("/root/Main").add_child(_scroll_bar)
	
func _set_windows_position(scrolling: float, smooth_move: bool) -> float:
	_cursor_y = PADDING_TOP + scrolling
	_cursor_x = PADDING_LEFT
	var max_window_height: float = 0
	
	for app_group in _organized_window_list:
		max_window_height = 0
		for window in app_group:
			var window_size = window.get_size()
			if _cursor_x + window_size.x > 800 - PADDING_RIGHT:
				_cursor_x = PADDING_LEFT
				_cursor_y += max_window_height + LINE_SEPARATION
				max_window_height = 0
				
			if smooth_move:
				window.smooth_move(_cursor_x, _cursor_y)
			else:
				window.set_pos(_cursor_x, _cursor_y)
			window.smooth_scale(1)
			_cursor_x += window_size.x + SPACE_WIDTH
			if window_size.y > max_window_height:
				max_window_height = window_size.y
			
		_cursor_x = PADDING_LEFT
		_cursor_y += max_window_height + GROUP_SEPARATION
	
	_cursor_y += PADDING_BOTTOM
	return _cursor_y
	
func _window_click_check() -> void:
	if not Input.is_action_just_pressed("MOUSE_LEFT"):
		return
		
	var mouse_pos: = get_global_mouse_position()
	for window_group in _organized_window_list:
		for window in window_group:
			var window_pos: Vector2 = window.get_pos()
			var window_size: Vector2 = window.get_size()
			if mouse_pos.x >= window_pos.x and mouse_pos.y >= window_pos.y \
			and mouse_pos.x <= window_pos.x + window_size.x \
			and mouse_pos.y <= window_pos.y + window_size.y:
				_return_windows_to_previous_pos()
				window.smooth_move(400 - window_size.x, 250 - window_size.y)
				window.place_window_on_top()
				GlobalVars.button_press_detected = true
				_close_app()
				
func _return_windows_to_previous_pos() -> void:
	for i in _window_list.get_child_count():
		var previous_pos = _previous_window_pos_list[i]
		var window = _window_list.get_child(i)
		window.smooth_move(previous_pos.x, previous_pos.y)
		window.smooth_scale(2)
