extends Node

@onready var desktop_icon_list = get_node("/root/Main/Desktop")
		
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
