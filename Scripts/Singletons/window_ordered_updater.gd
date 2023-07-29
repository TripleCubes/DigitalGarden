extends Node

@onready var window_list = get_node("/root/Main/WindowList")
@onready var hidden_window_list = get_node("/root/Main/HiddenWindowList")
@onready var desktop_icon_list = get_node("/root/Main/Desktop")

func _process(delta):
	ShowAllWindows.update(delta)
	
	GlobalVars.decided_cursor_shape = GlobalVars.CursorShape.POINTER
	for i in range(window_list.get_child_count() - 1, -1, -1):
		window_list.get_child(i).update(delta)
		
	for i in range(desktop_icon_list.get_child_count() - 1, -1, -1):
		desktop_icon_list.get_child(i).update(delta)
		
	for window in hidden_window_list.get_children():
		window.update(delta)
