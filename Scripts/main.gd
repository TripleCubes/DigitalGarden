extends Node2D

func _ready():
	var desktop_icon__show_all_windows: = Game_DesktopIcon.new(AppNames.NOT_SET, 10, 10, func show_all_windows():
		ShowAllWindows.open_app()
	, preload("res://Assets/Sprites/DesktopIcons/desktop_icon__all_apps.png"))
	$Desktop.add_child(desktop_icon__show_all_windows)
	
	_add_desktop_icon(AppNames.POT, preload("res://Assets/Sprites/DesktopIcons/desktop_icon__pot.png"),
						10, 110)
	_add_desktop_icon(AppNames.WATER, preload("res://Assets/Sprites/DesktopIcons/desktop_icon__water.png"),
						10, 210)
	_add_desktop_icon(AppNames.WATERING_CAN, preload("res://Assets/Sprites/DesktopIcons/desktop_icon__watering_can.png"),
						10, 310)
	_add_desktop_icon(AppNames.GARDEN, preload("res://Assets/Sprites/DesktopIcons/desktop_icon__garden.png"),
						10, 410)
	_add_desktop_icon(AppNames.VALLEY, preload("res://Assets/Sprites/DesktopIcons/desktop_icon__valley.png"),
						110, 10)
	_add_desktop_icon(AppNames.SEED, preload("res://Assets/Sprites/DesktopIcons/desktop_icon__seed.png"),
						110, 110)

func _process(_delta):
	GlobalVars.button_press_detected = false
	
	if Input.is_action_just_pressed("KEY_1"):
		GlobalVars.show_debug_informations = not GlobalVars.show_debug_informations
	
	if Input.is_action_just_pressed("KEY_2"):
		print(get_global_mouse_position())
	
func _add_desktop_icon(app_name: int, texture: Texture2D, x: float, y: float):
	var desktop_icon: = Game_DesktopIcon.new(app_name, x, y, func icon_func():
		var window: = Game_Window.new(app_name)
		$WindowList.add_child(window)
	, texture)
	$Desktop.add_child(desktop_icon)
