extends Node2D

func _ready():
	$Desktop.get_node("Icon_ShowAllWindows").icon_function = func show_all_windows():
		print("show all windows")

func _process(_delta):
	GlobalVars.button_press_detected = false
	
	if Input.is_action_just_pressed("KEY_1"):
		for window in $WindowList.get_children():
			window.smooth_scale(1)
		for icon in $Desktop.get_children():
			icon.smooth_scale(1)
			
	if Input.is_action_just_pressed("KEY_2"):
		for window in $WindowList.get_children():
			window.smooth_scale(2)
		for icon in $Desktop.get_children():
			icon.smooth_scale(2)
			
	if Input.is_action_just_pressed("KEY_3"):
		for window in $WindowList.get_children():
			window.smooth_scale(3)
		for icon in $Desktop.get_children():
			icon.smooth_scale(3)
