class_name Game_DragWindowIn
extends Node2D

var has_window: bool = false
var allow_get_window_out: bool = false

func _init(x: float, y: float, w: float, h: float):
	_button = Game_Button.new(x, y, w, h, GlobalConsts.WINDOW_DEFAULT_SCALE, Color(0, 0, 0, 0))
	add_child(_button)
	_button.show_button()
	
func get_pos() -> Vector2:
	return _button.get_button_pos()
	
func update(_delta: float) -> void:
	_button.update(_delta)
	
	if has_window:
		if allow_get_window_out and _button.just_pressed():
			var button_pos: = _button.global_position		
			has_window = false
			var window: = Game_Window.new(AppNames.POT, button_pos.x, button_pos.y)
			window.get_app().grown = true
			_window_list.add_child(window)
		return
	
	for window in _window_list.get_children():
		if window.is_queued_for_deletion():
			continue
			
		if not _accept(window):
			continue
			
		if not Input.is_action_just_released("MOUSE_LEFT") or Time.get_ticks_msec() - window.bar_released_at > 100:
			continue
			
		var button_pos: = _button.global_position
		var button_size: = _button.get_button_size()
			
		if GlobalFunctions.box_collision_check(window._x.get_var(), window._w, button_pos.x, button_size.x, 
														GlobalConsts.WINDOW_DEFAULT_SCALE) \
				and GlobalFunctions.box_collision_check(window._y.get_var(), window._h, button_pos.y, button_size.y, 
														GlobalConsts.WINDOW_DEFAULT_SCALE):
			window.queue_free()
			has_window = true
			return
	
@onready var _window_list: Node2D = get_node("/root/Main/WindowList")

var _button: Game_Button

func _accept(window: Game_Window) -> bool:
	return window.get_app_name() == AppNames.POT# and window.get_app().grown
