class_name App_Tasks
extends Node2D

func _init(window: Game_Window):
	_window = window
	
	_window._w = 120
	_window._h = 170
	_window._min_w = 120
	_window._max_w = 120
	_window._min_h = 170
	_window._max_h = 170
	
	_task_10_flowers = Game_Task.new(15, preload("res://Assets/Sprites/Apps/Tasks/app__tasks__ram.png"),
						"Ship 10 flowers", func sub_text() -> String:
		return str(10 - Stats.flowers_shipped) + " more"
	, _window._scale, func task() -> bool:
		return true
	)
	add_child(_task_10_flowers)
	
func draw_app_content() -> void:
	pass
	
func update(_delta: float) -> void:
	_task_10_flowers.update(_delta)
	
#@onready var _window_list: Node2D = get_node("/root/Main/WindowList")
#const _texture__: Texture2D = preload("res://Assets/Sprites/Apps/")
var _window: Game_Window

var _task_10_flowers: Game_Task
