class_name App_TicTacToe
extends Node2D

func _init(window: Game_Window):
	_window = window
	
#	_window._w = 
#	_window._h = 
#	_window._min_w = 
#	_window._max_w = 
#	_window._min_h = 
#	_window._max_h = 
	
func draw_app_content() -> void:
	pass
	
func update(_delta: float) -> void:
	pass
	
#@onready var _window_list: Node2D = get_node("/root/Main/WindowList")
#const _texture__: Texture2D = preload("res://Assets/Sprites/Apps/")
var _window: Game_Window
