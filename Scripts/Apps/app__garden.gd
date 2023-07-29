class_name App_Garden
extends Node2D

func _init(window: Game_Window):
	_window = window
	
	_window._w = 200
	_window._h = 200
	_window._min_w = 70
	_window._max_w = 200
	_window._min_h = 70
	_window._max_h = 200
	
	_drag_window_into_list.append(Game_DragWindowIn.new(97, 136, 56/2, 59/2, _accept))
	_drag_window_into_list.append(Game_DragWindowIn.new(181, 137, 56/2, 59/2, _accept))
	_drag_window_into_list.append(Game_DragWindowIn.new(256, 137, 56/2, 59/2, _accept))
	_drag_window_into_list.append(Game_DragWindowIn.new(100, 230, 56/2, 59/2, _accept))
	_drag_window_into_list.append(Game_DragWindowIn.new(182, 228, 56/2, 59/2, _accept))
	_drag_window_into_list.append(Game_DragWindowIn.new(261, 229, 56/2, 59/2, _accept))
	for drag_window_into in _drag_window_into_list:
		add_child(drag_window_into)
		
func draw_app_content() -> void:
	_window.draw_texture_rect_region(_texture__garden, 
								Rect2(5, 15, min(200, _window._w - 10), min(190, _window._h - 20)),
								Rect2(0, 0, min(200, _window._w - 10), min(190, _window._h - 20)))
								
	for drag_window_into in _drag_window_into_list:
		if not drag_window_into.has_window:
			continue
			
		var pos: Vector2 = drag_window_into.get_pos()
		_window.draw_texture(_texture__pot, Vector2(pos.x / 2 - 13, pos.y / 2 - 45))
	
func update(_delta: float) -> void:
	for drag_window_into in _drag_window_into_list:
		drag_window_into.update(_delta)
		
#@onready var _window_list: Node2D = get_node("/root/Main/WindowList")
const _texture__garden: Texture2D = preload("res://Assets/Sprites/Apps/Garden/app__garden__garden.png")
const _texture__pot: Texture2D = preload("res://Assets/Sprites/Apps/Pot/app__pot__pot__grown_2.png")
var _window: Game_Window
var _drag_window_into_list: = []

func _min(a: float, b: float) -> float:
	if a < b: 
		return a
	return b
	
func _accept(window: Game_Window) -> bool:
	return window.get_app_name() == AppNames.POT #and window.get_app().grown
