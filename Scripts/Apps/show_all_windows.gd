extends Node2D

const PADDING_TOP: float = 40
const GROUP_SEPARATION: float = 30
const LINE_SEPARATION: float = 20
const PADDING_BOTTOM: float = 40

const PADDING_LEFT: float = 80
const ICON_PADDING_LEFT: float = 30
const PADDING_RIGHT: float = 30
const SPACE_WIDTH: float = 10

func open_app() -> void:
	if _app_opening:
		return
		
	if _window_list.get_child_count() == 0:
		return
		
	_scroll_bar.show_scrollbar()
	_scroll_bar.scroll_to_zero()
	
	_set_windows_data()
	var page_size: = _set_windows_position(0, true)
	_scroll_bar.set_page_size(page_size, 500)
		
	_app_opening = true
	
@onready var _window_list: Node2D = get_node("/root/Main/WindowList")
@onready var _desktop_icon_list: Node2D = get_node("/root/Main/Desktop")

var _scroll_bar: = Game_ScrollBar.new(800, 0, false, 500)

var _previous_window_pos_list: = []
var _previous_desktop_icon_pos_list: = []

var _organized_window_list: = []

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
	
	GlobalVars.button_press_detected = true	
	
func _ready():
	for i in AppNames.NUMBER_OF_NAMES:
		_organized_window_list.append([])
		
	get_node("/root/Main").add_child(_scroll_bar)
	
func _set_windows_position(scrolling: float, smooth_move: bool) -> float:
	var cursor_y: float = PADDING_TOP + scrolling
	var cursor_x: float = PADDING_LEFT
	var max_window_height: float = 0
	
	for app_name in _organized_window_list.size():
		var app_group: Array = _organized_window_list[app_name]
		max_window_height = 50
		
		if smooth_move:
			_get_desktop_icon_by_app_name(app_name).smooth_move(ICON_PADDING_LEFT, cursor_y)
		else:
			_get_desktop_icon_by_app_name(app_name).set_pos(ICON_PADDING_LEFT, cursor_y)
		
		for window in app_group:
			var window_size = window.get_size()
			if cursor_x + window_size.x > 800 - PADDING_RIGHT:
				cursor_x = PADDING_LEFT
				cursor_y += max_window_height + LINE_SEPARATION
				max_window_height = 0
				
			if smooth_move:
				window.smooth_move(cursor_x, cursor_y)
			else:
				window.set_pos(cursor_x, cursor_y)
			window.smooth_scale(1)
			cursor_x += window_size.x + SPACE_WIDTH
			if window_size.y > max_window_height:
				max_window_height = window_size.y
			
		cursor_x = PADDING_LEFT
		cursor_y += max_window_height + GROUP_SEPARATION
	
	cursor_y += PADDING_BOTTOM
	return cursor_y
	
func _set_windows_data() -> void:
	_previous_window_pos_list.clear()
	_previous_desktop_icon_pos_list.clear()
	
	for app_group in _organized_window_list:
		app_group.clear()
	
	for window in _window_list.get_children():
		if window.is_queued_for_deletion():
			continue
		_previous_window_pos_list.append(window.get_destination())
		_organized_window_list[window.get_app_name()].append(window)
		
	for icon in _desktop_icon_list.get_children():
		_previous_desktop_icon_pos_list.append(icon.get_destination())
	
func _window_click_check() -> void:
	if not Input.is_action_just_pressed("MOUSE_LEFT"):
		return
		
	var mouse_pos: = get_global_mouse_position()
	for window_group in _organized_window_list:
		for window in window_group:
			var window_pos: Vector2 = window.get_pos()
			var window_size: Vector2 = window.get_size()
			if _close_button_hovered(mouse_pos, window_pos, window_size):
				window.queue_free()
				_set_windows_data()
				_set_windows_position(_scroll_bar.get_value_pixel(), true)
				if _previous_window_pos_list.size() == 0:
					_close_app()
				return
			if mouse_pos.x >= window_pos.x and mouse_pos.y >= window_pos.y \
			and mouse_pos.x <= window_pos.x + window_size.x \
			and mouse_pos.y <= window_pos.y + window_size.y:
				_return_windows_to_previous_pos()
				var move_to_x = randf_range(30, 60)
				var move_to_y = randf_range(30, 60)
				window.smooth_move(move_to_x, move_to_y)
				window.place_window_on_top()
				_close_app()
				
func _close_button_hovered(mouse_pos: Vector2, window_pos: Vector2, window_size: Vector2) -> bool:
	if mouse_pos.x >= window_pos.x + (window_size.x - Game_Window.WINDOW_BAR_H) \
	and mouse_pos.y >= window_pos.y + 1 \
	and mouse_pos.x <= window_pos.x + (window_size.x - Game_Window.WINDOW_BAR_H) + 9 \
	and mouse_pos.y <= window_pos.y + 1 + 9:
		return true
	return false
	
func _return_windows_to_previous_pos() -> void:
	for i in _window_list.get_child_count():
		var previous_pos = _previous_window_pos_list[i]
		var window = _window_list.get_child(i)
		window.smooth_move(previous_pos.x, previous_pos.y)
		window.smooth_scale(2)
		
	for i in _desktop_icon_list.get_child_count():
		var previous_pos = _previous_desktop_icon_pos_list[i]
		var icon = _desktop_icon_list.get_child(i)
		icon.smooth_move(previous_pos.x, previous_pos.y)
		
func _get_desktop_icon_by_app_name(app_name: int) -> Game_DesktopIcon:
	for icon in _desktop_icon_list.get_children():
		if icon.get_app_name() == app_name:
			return icon
	return null
