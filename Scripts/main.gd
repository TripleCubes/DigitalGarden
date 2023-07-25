extends Node2D

func _ready():
	$Desktop.get_node("Icon_ShowAllWindows").icon_function = func show_all_windows():
		print("show all windows")

func _process(_delta):
	GlobalVars.button_press_detected = false
