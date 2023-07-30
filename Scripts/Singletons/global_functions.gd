extends Node

@onready var _desktop_icon_list = get_node("/root/Main/Desktop")
@onready var _window_list: Node2D = get_node("/root/Main/WindowList")
var _font_theme: Theme = preload("res://Assets/Fonts/font.tres")
		
func ease_in_out(num: float) -> float:
	return -(cos(PI * num) - 1) / 2;
	
func box_collision_check(x1: float, w1: float, x2: float, w2: float, scale: float) -> bool:
	if (x1 >= x2 and x1 <= x2 + w2*scale) or (x1 + w1*scale >= x2 and x1 + w1*scale <= x2 + w2*scale) \
	or (x2 >= x1 and x2 <= x1 + w1*scale) or (x2 + w2*scale >= x1 and x2 + w2*scale <= x1 + w1*scale):
		return true
	return false
	
func overllap(window1: Game_Window, window2: Game_Window) -> bool:
	var window1_pos: = window1.get_pos()
	var window1_size: = window1.get_size()
	var window1_scale: = window1.get_window_scale()
	var window2_pos: = window2.get_pos()
	var window2_size: = window2.get_size()
	
	return box_collision_check(window1_pos.x, window1_size.x, window2_pos.x, window2_size.x, window1_scale) \
	and box_collision_check(window1_pos.y, window1_size.y, window2_pos.y, window2_size.y, window1_scale)
	
func has_water_window_on_top(_window: Game_Window) -> bool:
	for window in _window_list.get_children():
		if window.get_app_name() != AppNames.WATER:
			continue
			
		if not window.get_app().pouring_water:
			return false
			
		var window_pos = window.get_pos()
		var self_window_pos = _window.get_pos()
		if window_pos.y < self_window_pos.y \
		and GlobalFunctions.box_collision_check(self_window_pos.x, 60, 
												window_pos.x + 25*_window.get_window_scale(), 60 - 50, 
												_window.get_window_scale()):
			return true
			
		return false
	return false
	
func setup_label(label: RichTextLabel, x: float, y: float, init_text: String = "") -> void:
	label.theme = _font_theme
	label.scroll_active = false
	label.position.x = x
	label.position.y = y
	label.size.x = 110
	label.size.y = 65
	label.text = init_text
	label.scale = Vector2(2, 2)
	
func place_valley_icon_on_top():
	_desktop_icon_list.move_child(GlobalVars.valley_icon, _desktop_icon_list.get_child_count() - 1)
	
func get_time() -> float:
	return (Time.get_ticks_msec() - GlobalVars.game_start_at) / 1000
