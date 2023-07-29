class_name App_Tasks
extends Node2D

func _init(window: Game_Window):
	_window = window
	
	_window._w = 120
	_window._h = 170
	_window._min_w = 120
	_window._max_w = 120
	_window._min_h = 170
	_window._max_h = 170
	
func draw_app_content() -> void:
	pass
	
func update(_delta: float) -> void:
	pass
	
#@onready var _window_list: Node2D = get_node("/root/Main/WindowList")
#const _texture__: Texture2D = preload("res://Assets/Sprites/Apps/")
var _window: Game_Window
