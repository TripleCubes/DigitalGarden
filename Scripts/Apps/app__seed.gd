class_name App_Seed
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
	_window.draw_texture(_texture__seed__seed_packet, Vector2(5, 10))
	
func update(_delta: float) -> void:
	if not _window.just_drag_released():
		return
		
	for window in _window_list.get_children():
		if window.get_app_name() != AppNames.POT:
			continue
		
		if GlobalFunctions.overllap(window, _window):
			window.get_app().put_seed()
			_window.queue_free()
	
@onready var _window_list: Node2D = get_node("/root/Main/WindowList")
const _texture__seed__seed_packet: Texture2D = preload("res://Assets/Sprites/Apps/Seed/app__seed__seed_packet.png")
var _window: Game_Window
