extends Node2D

const _texture__show_all_windows: Texture2D = preload("res://Assets/Sprites/DesktopIcons/desktop_icon__all_apps.png")

func _ready():
	for i in 30:
		var window: = Game_Window.new(randi_range(0, 5), randf_range(-10, 700), randf_range(-10, 400),
										randf_range(100, 250), randf_range(80, 230), 2)
		$WindowList.add_child(window)
	
	
	
	var desktop_icon__show_all_windows: = Game_DesktopIcon.new(10, 10, 1, func show_all_windows():
		ShowAllWindows.open_app()
	, _texture__show_all_windows)
	$Desktop.add_child(desktop_icon__show_all_windows)

func _process(_delta):
	GlobalVars.button_press_detected = false
