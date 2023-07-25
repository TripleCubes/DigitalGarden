extends Node2D

func _ready():
	$Desktop.get_node("Icon_ShowAllWindows").icon_function = func show_all_windows():
		print("show all windows")

func _process(_delta):
	GlobalVars.button_press_detected = false
	
	if Input.is_action_just_pressed("KEY_1"):
		for window in $WindowList.get_children():
			window.smooth_move(10, 10)
		for icon in $Desktop.get_children():
			icon.smooth_move(500, 200)
			
	if Input.is_action_just_pressed("KEY_2"):
		for window in $WindowList.get_children():
			window.smooth_move(200, 10)
		for icon in $Desktop.get_children():
			icon.smooth_move(200, 100)
			
	if Input.is_action_just_pressed("KEY_3"):
		for window in $WindowList.get_children():
			window.smooth_move(300, 300)
		for icon in $Desktop.get_children():
			icon.smooth_move(300, 300)
