class_name App_Water
extends Node2D

func _init(window: Game_Window):
	_window = window
	
	_window._w = 60
	_window._h = 80
	_window._min_w = 60
	_window._max_w = 60
	_window._min_h = 80
	_window._max_h = 80
	
	_button__get_water = Game_Button.new(36, 80, 12, 12, 
											GlobalConsts.WINDOW_DEFAULT_SCALE, Color(0, 0, 0, 0))
	add_child(_button__get_water)
	_button__get_water.show_button()
	
	_progress_bar = Game_ProgressBar.new(5, 15, 50, _window._scale)
	add_child(_progress_bar)
	_progress_bar.color = GlobalConsts.COLOR_BLUE
	_progress_bar.progress_bar_visible = true
	_progress_bar.fill_time_sec = 120
	_progress_bar.progress = 1
	_progress_bar.reverse_fill_time_sec = 10
	_progress_bar.paused = false
	
func draw_app_content() -> void:
	var window_size = _window.get_size()
	
	_window.draw_texture(_texture__water_dispenser, Vector2(10, window_size.x - 1 - 20))
	
	if pouring_water:
		_window.draw_texture(_texture__water__top, Vector2(27, 56))
		_window.draw_texture_rect(_texture__water, Rect2(27, 66, 10, 1000), true)
	
func update(_delta: float) -> void:
	_button__get_water.update(_delta)
	_progress_bar.update(_delta)
	
	if _progress_bar.progress == 1 and _button__get_water.just_pressed():
		pouring_water = true
		_progress_bar.reversed = true
		
	if _progress_bar.progress == 0:
		pouring_water = false
		_progress_bar.reversed = false
	
const _texture__water_dispenser: Texture2D = preload("res://Assets/Sprites/Apps/Water/app__water__water_dispenser.png")
const _texture__water: Texture2D = preload("res://Assets/Sprites/Apps/Water/app__water__water.png")
const _texture__water__top: Texture2D = preload("res://Assets/Sprites/Apps/Water/app__water__water__top.png")
var _window: Game_Window
var _button__get_water: Game_Button
var pouring_water: bool = false

var _progress_bar: Game_ProgressBar
