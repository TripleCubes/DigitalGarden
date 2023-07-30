class_name App_Tree
extends Node2D

const WATER_REQUEST_DELAY: float = 8

#@onready var _window_list: Node2D = get_node("/root/Main/WindowList")
const _texture__tree_0: Texture2D = preload("res://Assets/Sprites/Apps/Tree/app__tree__0.png")
const _texture__tree_1: Texture2D = preload("res://Assets/Sprites/Apps/Tree/app__tree__1.png")
const _texture__tree_2: Texture2D = preload("res://Assets/Sprites/Apps/Tree/app__tree__2.png")
const _texture__tree_3: Texture2D = preload("res://Assets/Sprites/Apps/Tree/app__tree__3.png")
const _texture__tree_4: Texture2D = preload("res://Assets/Sprites/Apps/Tree/app__tree__4.png")

var _window: Game_Window

var created_at: float = Time.get_ticks_msec()
var phase: float = 0

var _progress_bar: Game_ProgressBar
var _bubble: Game_Bubble

var _last_watered_at: float = Time.get_ticks_msec()

func _init(window: Game_Window):
	_window = window
	
	_window._w = 90
	_window._h = 130
	_window._min_w = 90
	_window._max_w = 90
	_window._min_h = 130
	_window._max_h = 130
	
	_progress_bar = Game_ProgressBar.new(5, 118, 80, _window._scale)
	_progress_bar.progress_bar_visible = true
	_progress_bar.fill_time_sec = 10
	_progress_bar.paused = false
	_progress_bar.color = GlobalConsts.COLOR_GREEN
	add_child(_progress_bar)
	
	_bubble = Game_Bubble.new(126/2, 30, 20, 20, Game_Bubble.PointyDir.BOTTOM_LEFT, _window._scale)
	add_child(_bubble)
	_bubble.icon = preload("res://Assets/Sprites/Apps/Pot/app__pot__water_drop.png")
	
func put_water() -> void:
	_last_watered_at = Time.get_ticks_msec()
	_progress_bar.paused = false
	_bubble.bubble_visible = false
	
func draw_app_content() -> void:
	if phase == 0:
		_window.draw_texture(_texture__tree_0, Vector2(5, 15))
		
	if phase == 1:
		_window.draw_texture(_texture__tree_1, Vector2(5, 15))
		
	if phase == 2:
		_window.draw_texture(_texture__tree_2, Vector2(5, 15))
		
	if phase == 3:
		_window.draw_texture(_texture__tree_3, Vector2(5, 15))
		
	if phase == 4:
		_window.draw_texture(_texture__tree_4, Vector2(5, 15))
	
func update(_delta: float) -> void:
	_progress_bar.update(_delta)
	_bubble.update(_delta)
	
	if phase >= 4:
		return
		
	if _progress_bar.progress == 1:
		_progress_bar.progress = 0
		phase += 1
		if phase == 4:
			_progress_bar.progress_bar_visible = false
			Stats.tree_grown = true
			
	if Time.get_ticks_msec() - _last_watered_at > WATER_REQUEST_DELAY * 1000:
		_progress_bar.paused = true
		_bubble.bubble_visible = true
		
	if GlobalFunctions.has_water_window_on_top(_window):
		put_water()
