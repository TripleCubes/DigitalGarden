class_name App_WateringCan
extends Node2D

func _init(window: Game_Window):
	_window = window
	
	_window._w = 60
	_window._h = 60
	_window._min_w = 60
	_window._max_w = 60
	_window._min_h = 60
	_window._max_h = 60
	
func draw_app_content() -> void:
	if not filled:
		_window.draw_texture(_texture__watering_can, Vector2(5, 10))
	else:
		_window.draw_texture(_texture__watering_can__filled, Vector2(5, 10))
	
func update(_delta: float) -> void:
	if GlobalFunctions.has_water_window_on_top(_window):
		filled = true
		
		
		
	if not _window.just_drag_released():
		return
		
	for window in _window_list.get_children():
		if window.get_app_name() != AppNames.POT:
			continue
		
		if GlobalFunctions.overllap(window, _window):
			window.get_app().put_water()
			filled = false
	
@onready var _window_list: Node2D = get_node("/root/Main/WindowList")
const _texture__watering_can: Texture2D = preload("res://Assets/Sprites/Apps/WateringCan/app__watering_can__watering_can.png")
const _texture__watering_can__filled: Texture2D = preload("res://Assets/Sprites/Apps/WateringCan/app__watering_can__watering_can__filled.png")

var _window: Game_Window
var filled: bool = false
