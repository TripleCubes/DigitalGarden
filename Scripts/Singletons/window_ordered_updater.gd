extends Node

@onready var window_list = get_node("/root/Main/WindowList")
@onready var desktop_icon_list = get_node("/root/Main/Desktop")

func _process(delta):
	ShowAllWindows.update(delta)
	
	for i in range(window_list.get_child_count() - 1, -1, -1):
		window_list.get_child(i).update(delta)
		
	for i in range(desktop_icon_list.get_child_count() - 1, -1, -1):
		desktop_icon_list.get_child(i).update(delta)