class_name App_Crow
extends Node2D

const JUMP_DELAY: float = 5 # Secs

@onready var _created_at: float = Time.get_ticks_msec()
var _jumped_times: int = 0

func _init(window: Game_Window):
	_window = window
	
	_window._w = 60
	_window._h = 60
	_window._min_w = 60
	_window._max_w = 60
	_window._min_h = 60
	_window._max_h = 60
	
func draw_app_content() -> void:
	_window.draw_texture(_texture__crow, Vector2(5, 15))
	
func update(_delta: float) -> void:
	if JUMP_DELAY * 1000 * (_jumped_times + 1) + _created_at < Time.get_ticks_msec():
		_jumped_times += 1
		if not ShowAllWindows._app_opening:
			_jump()
			
	if Time.get_ticks_msec() - _created_at > 60 * 1000:
		_window.queue_free()
		
	for window in _window_list.get_children():
		if window.get_app_name() != AppNames.POT:
			continue
		
		if not window.get_app().grown:
			continue
			
		if GlobalFunctions.overllap(_window, window):
			window.get_app().dead = true
			window.get_app().grown = false
			Stats.flowers_dead += 1
	
@onready var _window_list: Node2D = get_node("/root/Main/WindowList")
const _texture__crow: Texture2D = preload("res://Assets/Sprites/Apps/Crow/app__crow__crow.png")
var _window: Game_Window

func _distance_sqr(x1: float, y1: float, x2: float, y2: float) -> float:
	var dx: = x1 - x2
	var dy: = y1 - y2
	return dx*dx + dy*dy
	
func _jump() -> void:
	var min_distance: float = 99999999
	var target_pos: Vector2
	var found: bool = false
	for window in _window_list.get_children():
		if window.get_app_name() != AppNames.POT:
			continue
			
		if not window.get_app().grown:
			continue
			
		var window_pos: Vector2 = window.get_pos()
		var self_window_pos: = _window.get_pos()
		var distance: = _distance_sqr(window_pos.x, window_pos.y, self_window_pos.x, self_window_pos.y)
		if distance < min_distance:
			min_distance = distance
			target_pos = window_pos
			found = true
	
	var inertia: Vector2
	
	if found:
		inertia = target_pos - _window.get_pos()
		inertia = inertia.normalized()
		inertia = inertia.rotated(deg_to_rad(randf_range(-40, 40)))
		
	else:
		inertia = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		
	var pos = _window.get_pos()
	pos += inertia * 120
	_window.smooth_move(pos.x, pos.y)
