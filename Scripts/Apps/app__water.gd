class_name App_Water
extends Node2D

func _init(window: Game_Window):
	_window = window
	
	_button__get_water = Game_Button.new(24 * GlobalConsts.WINDOW_DEFAULT_SCALE, 20 * GlobalConsts.WINDOW_DEFAULT_SCALE,
											12, 12, 
											GlobalConsts.WINDOW_DEFAULT_SCALE, Color(0, 0, 0, 0))
	add_child(_button__get_water)
	_button__get_water.show_button()
	
func draw_app_content() -> void:
	if _pouring_water:
		_window.draw_rect(Rect2(24, 30, 12, 200), Color(0.84, 0.94, 0.89))
	
func update(_delta: float) -> void:
	_button__get_water.update(_delta)
	
	if _button__get_water.just_pressed():
		_pouring_water = not _pouring_water
	
var _window: Game_Window
var _button__get_water: Game_Button
var _pouring_water: bool = false
