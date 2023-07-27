class_name App_Pot
extends Node2D

func _init(window: Game_Window):
	_window = window
	
func draw_app_content() -> void:
	if not has_seed:
		_window.draw_texture(_texture__pot, Vector2(5, 10))
	else:
		_window.draw_texture(_texture__pot__grown, Vector2(5, 10))
	
func update(_delta: float) -> void:
	pass
			
@onready var _window_list: Node2D = get_node("/root/Main/WindowList")
const _texture__pot: Texture2D = preload("res://Assets/Sprites/Apps/Pot/app__pot__pot.png")
const _texture__pot__grown: Texture2D = preload("res://Assets/Sprites/Apps/Pot/app__pot__pot__grown.png")
var _window: Game_Window
var has_seed: bool = false
