extends Node2D

const _texture__desktop_icon__show_all_windows: Texture2D = preload("res://Assets/Sprites/DesktopIcons/desktop_icon__all_apps.png")
const _texture__desktop_icon__pot: Texture2D = preload("res://Assets/Sprites/DesktopIcons/desktop_icon__pot.png")

func _ready():
	for i in 3:
		var window: = Game_Window.new(randi_range(0, 5), randf_range(-10, 700), randf_range(-10, 400),
										randf_range(100, 250), randf_range(80, 230), 2, null)
		$WindowList.add_child(window)
	
	var desktop_icon__show_all_windows: = Game_DesktopIcon.new(AppNames.NOT_SET, 10, 10, 1, func show_all_windows():
		ShowAllWindows.open_app()
	, _texture__desktop_icon__show_all_windows)
	$Desktop.add_child(desktop_icon__show_all_windows)
	
	var desktop_icon__pot: = Game_DesktopIcon.new(AppNames.POT, 10, 50, 1, func show_all_windows():
		var window: = Game_Window.new(AppNames.POT, randf_range(-10, 700), randf_range(-10, 400),
										randf_range(100, 250), randf_range(80, 230), 2, App_Pot.new())
		$WindowList.add_child(window)
	, _texture__desktop_icon__pot)
	$Desktop.add_child(desktop_icon__pot)

func _process(_delta):
	GlobalVars.button_press_detected = false
