class_name App_WateringCan
extends Node2D

func _init(window: Game_Window):
	_window = window
	
func draw_app_content() -> void:
	if not filled:
		_window.draw_texture(_texture__watering_can, Vector2(5, 10))
	else:
		_window.draw_texture(_texture__watering_can__filled, Vector2(5, 10))
	
func update(_delta: float) -> void:
	if _has_water_window_on_top():
		filled = true
	
@onready var _window_list: Node2D = get_node("/root/Main/WindowList")
const _texture__watering_can: Texture2D = preload("res://Assets/Sprites/Apps/WateringCan/app__watering_can__watering_can.png")
const _texture__watering_can__filled: Texture2D = preload("res://Assets/Sprites/Apps/WateringCan/app__watering_can__watering_can__filled.png")

var _window: Game_Window
var filled: bool = false

func _has_water_window_on_top() -> bool:
	for window in _window_list.get_children():
		if window.get_app_name() != AppNames.WATER:
			continue
			
		if not window.get_app().pouring_water:
			return false
			
		var window_pos = window.get_pos()
		var self_window_pos = _window.get_pos()
		if window_pos.y < self_window_pos.y \
		and GlobalFunctions.box_collision_check(self_window_pos.x, 60, 
												window_pos.x + 25*_window.get_window_scale(), 60 - 50, 
												_window.get_window_scale()):
			return true
			
		return false
	return false
