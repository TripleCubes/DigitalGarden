extends Node

@onready var desktop_icon_list = get_node("/root/Main/Desktop")

#func unfocus_all_desktop_icons() -> void:
#	for icon in desktop_icon_list.get_children():
#		icon.focused = false
		
func ease_in_out(num: float) -> float:
	return -(cos(PI * num) - 1) / 2;