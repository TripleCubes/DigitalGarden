class_name App_Water
extends Node2D

func _init(window: Game_Window):
	_window = window
	
	_button__get_water = Game_Button.new(36, 40, 12, 12, 
											GlobalConsts.WINDOW_DEFAULT_SCALE, Color(0, 0, 0, 0))
	add_child(_button__get_water)
	_button__get_water.show_button()
	
func draw_app_content() -> void:
	var window_size = _window.get_size()
	
	_window.draw_texture(_texture__water_dispenser, Vector2(10, window_size.x - 1 - 40))
	
	if _pouring_water:
		_window.draw_texture(_texture__water__top, Vector2(27, 36))
		_window.draw_texture_rect(_texture__water, Rect2(27, 46, 10, 1000), true)
	
func update(_delta: float) -> void:
	_button__get_water.update(_delta)
	
	if _button__get_water.just_pressed():
		_pouring_water = not _pouring_water
	
const _texture__water_dispenser: Texture2D = preload("res://Assets/Sprites/Apps/Water/_app__water__water_dispenser.png")
const _texture__water: Texture2D = preload("res://Assets/Sprites/Apps/Water/_app__water__water.png")
const _texture__water__top: Texture2D = preload("res://Assets/Sprites/Apps/Water/_app__water__water__top.png")
var _window: Game_Window
var _button__get_water: Game_Button
var _pouring_water: bool = false
