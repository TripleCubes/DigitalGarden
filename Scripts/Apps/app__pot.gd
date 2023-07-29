class_name App_Pot
extends Node2D

const WATER_REQUEST_TIME: float = 25

func _init(window: Game_Window):
	_window = window
	
	_window._w = 60
	_window._h = 100
	_window._min_w = 60
	_window._max_w = 60
	_window._min_h = 100
	_window._max_h = 100
	
	_progress_bar = Game_ProgressBar.new(5, 15, 50, _window._scale)
	add_child(_progress_bar)
	
	_bubble = Game_Bubble.new(35, 30, 20, 20, Game_Bubble.PointyDir.BOTTOM_LEFT, _window._scale)
	add_child(_bubble)
	_bubble.icon = _texture__pot__water_drop
	
func draw_app_content() -> void:
	if grown: 
		_window.draw_texture(_texture__pot__grown_2, Vector2(5, 30))
	elif has_seed:
		_window.draw_texture(_texture__pot__grown, Vector2(5, 30))
	else:
		_window.draw_texture(_texture__pot, Vector2(5, 30))
	
func update(_delta: float) -> void:
	_progress_bar.update(_delta)
	_bubble.update(_delta)
	
	if _progress_bar.progress == 1:
		grown = true
		_progress_bar.progress_bar_visible = false
	
	if has_seed and not grown and Time.get_ticks_msec() - _last_watered_at > WATER_REQUEST_TIME * 1000:
		_progress_bar.paused = true
		_bubble.bubble_visible = true
		
	if GlobalFunctions.has_water_window_on_top(_window):
		put_water()
	
func put_seed() -> void:
	has_seed = true
	_progress_bar.progress_bar_visible = true
	_progress_bar.color = GlobalConsts.COLOR_GREEN
	_progress_bar.paused = false
	_progress_bar.fill_time_sec = 60
	
	_last_watered_at = Time.get_ticks_msec()
	
func put_water() -> void:
	if grown:
		return
		
	_last_watered_at = Time.get_ticks_msec()
	_progress_bar.paused = false
	_bubble.bubble_visible = false
			
@onready var _window_list: Node2D = get_node("/root/Main/WindowList")
const _texture__pot: Texture2D = preload("res://Assets/Sprites/Apps/Pot/app__pot__pot.png")
const _texture__pot__grown: Texture2D = preload("res://Assets/Sprites/Apps/Pot/app__pot__pot__grown.png")
const _texture__pot__grown_2: Texture2D = preload("res://Assets/Sprites/Apps/Pot/app__pot__pot__grown_2.png")
const _texture__pot__water_drop: Texture2D = preload("res://Assets/Sprites/Apps/Pot/app__pot__water_drop.png")

var _window: Game_Window
var has_seed: bool = false
var grown: bool = false
var _last_watered_at = 0

var _progress_bar: Game_ProgressBar
var _bubble: Game_Bubble
