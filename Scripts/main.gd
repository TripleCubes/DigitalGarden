extends Node2D

const texture__show_all_windows: Texture2D = preload("res://Assets/Sprites/DesktopIcons/desktop_icon__all_apps.png")

func _ready():
	var window_window1: = Game_Window.new(100, 20, 100, 60, 2)
	
	$WindowList.add_child(window_window1)
	
	var desktop_icon__show_all_windows: = Game_DesktopIcon.new(10, 10, 1, func show_all_windows():
		window_window1.smooth_move(10, 10)
	, texture__show_all_windows)
	
	$Desktop.add_child(desktop_icon__show_all_windows)

func _process(_delta):
	GlobalVars.button_press_detected = false
