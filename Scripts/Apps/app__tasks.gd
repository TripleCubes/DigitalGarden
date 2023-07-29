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
	
	_task_list.append(Game_Task.new(15, preload("res://Assets/Sprites/Apps/Tasks/app__tasks__30_watering_cans.png"),
						"fill 30 watering cans", func sub_text() -> String:
		return str(10 - Stats.flowers_shipped) + " more"
	, _window._scale, func task() -> bool:
		return Stats.flowers_shipped >= 10
	))
	add_child(_task_list[0])
	
	_task_list.append(Game_Task.new(15 + 30, preload("res://Assets/Sprites/Apps/Tasks/app__tasks__10_flowers.png"),
						"Ship 10 flowers", func sub_text() -> String:
		return str(10 - Stats.flowers_shipped) + " more"
	, _window._scale, func task() -> bool:
		return Stats.flowers_shipped >= 10
	))
	add_child(_task_list[1])
	
	_task_list.append(Game_Task.new(15 + 30 * 2, preload("res://Assets/Sprites/Apps/Tasks/app__tasks__grow_big_tree.png"),
						"Grow big tree", func sub_text() -> String:
		return "Grow big tree"
	, _window._scale, func task() -> bool:
		return Stats.flowers_shipped >= 10
	))
	add_child(_task_list[2])
	
	_task_list.append(Game_Task.new(15 + 30 * 3, preload("res://Assets/Sprites/Apps/Tasks/app__tasks__3_dead_flowers.png"),
						"3 dead flowers", func sub_text() -> String:
		return ""
	, _window._scale, func task() -> bool:
		return Stats.flowers_shipped >= 10
	))
	add_child(_task_list[3])
	
	_task_list.append(Game_Task.new(15 + 30 * 4, preload("res://Assets/Sprites/Apps/Tasks/app__tasks__done_all.png"),
						"Finish all tasks", func sub_text() -> String:
		return ""
	, _window._scale, func task() -> bool:
		return Stats.flowers_shipped >= 10
	))
	add_child(_task_list[4])
	
func draw_app_content() -> void:
	pass
	
func update(_delta: float) -> void:
	for task in _task_list:
		task.update(_delta)
	
#@onready var _window_list: Node2D = get_node("/root/Main/WindowList")
#const _texture__: Texture2D = preload("res://Assets/Sprites/Apps/")
var _window: Game_Window

var _task_list: = []
