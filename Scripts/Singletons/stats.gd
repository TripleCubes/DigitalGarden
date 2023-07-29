extends Node

@onready var _window_list: Node2D = get_node("/root/Main/WindowList")
var max_ram: int = 10
var flowers_shipped: int = 3

func get_current_ram() -> int:
	var result: int = 1
	for window in _window_list.get_children():
		result += AppNames.ram_list[window.get_app_name()]
	
	return result
	
func can_open_window(app_name: int) -> bool:
	if get_current_ram() + AppNames.ram_list[app_name] > max_ram:
		return false
	return true
