class_name Game_DesktopIcon
extends Node2D

const ICON_WIDTH: float = 20

func _init(app_name: int, x: float, y: float, icon_function: Callable, texture: Texture2D = null):
	_app_name = app_name
	_icon_function = icon_function
	_button = Game_Button.new(x, y, ICON_WIDTH, ICON_WIDTH, GlobalConsts.ICON_DEFAULT_SCALE, Color(0, 0, 0, 0), texture)
	add_child(_button)
	_button.show_button()
	
func get_app_name() -> int:
	return _app_name
	
func smooth_move(x: float, y: float) -> void:
	_button.smooth_move(x, y)
	
func set_pos(x: float, y: float) -> void:
	_button.set_button_pos(x, y)
	
func get_pos() -> Vector2:
	return _button.get_button_pos()
	
func smooth_scale(in_scale: float) -> void:
	_button.smooth_scale(in_scale)
	
func get_destination() -> Vector2:
	return _button.get_button_destination()

@onready var _desktop_icon_list = get_node("/root/Main/Desktop")
@onready var _window_list: Node2D = get_node("/root/Main/WindowList")
@onready var _hidden_window_list: Node2D = get_node("/root/Main/HiddenWindowList")

@onready var _button: Game_Button

var _app_name: int = 0

var _icon_function: Callable

var _previous_pos: Vector2
var _previous_mouse_pos: Vector2

var owned_window: Game_Window

func update(_delta) -> void:
	_button.update(_delta)
	
	var mouse_pos: = get_global_mouse_position()
			
	if _button.just_pressed() and not _button.transitioning_pos():
		_previous_pos = _button.get_button_pos()
		_previous_mouse_pos = mouse_pos
		_place_icon_on_top()
		
	if _button.pressed() and not _button.transitioning_pos():
		_button.set_button_pos(_previous_pos.x + mouse_pos.x - _previous_mouse_pos.x,
								_previous_pos.y + mouse_pos.y - _previous_mouse_pos.y)
								
	if _button.double_clicked():
		if AppNames.single_window_list[_app_name]:
			if owned_window.get_parent() == null:
				if Stats.can_open_window(_app_name):
					_window_list.add_child(owned_window)
					Stats.window_opened += 1
					
					if _app_name == AppNames.TIC_TAC_TOE:
						Stats.tick_opened = true
				else:
					Stats.ram_maxed = true
			elif owned_window.get_parent() == _hidden_window_list:
				if Stats.can_open_window(_app_name):
					_hidden_window_list.remove_child(owned_window)
					_window_list.add_child(owned_window)
					Stats.window_opened += 1
					
					if _app_name == AppNames.TIC_TAC_TOE:
						Stats.tick_opened = true
				else:
					Stats.ram_maxed = true
			else:
				owned_window.place_window_on_top()
			
		if not _icon_function.is_null():
			_icon_function.call()
		else:
			print("icon_function is null")
			
func _place_icon_on_top() -> void:
	_desktop_icon_list.move_child(self, _desktop_icon_list.get_child_count() - 1)
