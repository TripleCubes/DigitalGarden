class_name Game_DesktopIcon
extends Node2D

const ICON_WIDTH: float = 40

func _init(x: float, y: float, init_scale: float, icon_function: Callable, texture: Texture2D = null):
	_icon_function = icon_function
	_button = Game_Button.new(x, y, ICON_WIDTH, ICON_WIDTH, init_scale, texture)
	add_child(_button)
	_button.show_button()
	
func smooth_move(x: float, y: float) -> void:
	_button.smooth_move(x, y)
	
func smooth_scale(in_scale: float) -> void:
	_button.smooth_scale(in_scale)
	
func get_destination() -> Vector2:
	return _button.get_button_destination()

@onready var _desktop_icon_list = get_node("/root/Main/Desktop")

@onready var _button: Game_Button

var _icon_function: Callable

var _previous_pos: Vector2
var _previous_mouse_pos: Vector2

func _window_ordered_update(_delta) -> void:
	_button.update(_delta)
	
	var mouse_pos: = get_global_mouse_position()
	
	if _button.just_pressed():
		_previous_pos = _button.get_button_pos()
		_previous_mouse_pos = mouse_pos
		_place_icon_on_top()
		
	if _button.pressed():
		_button.set_button_pos(_previous_pos.x + mouse_pos.x - _previous_mouse_pos.x,
								_previous_pos.y + mouse_pos.y - _previous_mouse_pos.y)
		
	if _button.double_clicked():
		if not _icon_function.is_null():
			_icon_function.call()
		else:
			print("icon_function is null")
			
func _place_icon_on_top() -> void:
	_desktop_icon_list.move_child(self, _desktop_icon_list.get_child_count() - 1)
