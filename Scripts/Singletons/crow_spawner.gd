extends Node

var _spawn_list:= []

class _Spawn:
	var _at: float = 0
	var _num: float = 0
	var _spawned: bool = false
	
	func _init(at: float, num: float):
		_at = at
		_num = num
		
	func update():
		if _spawned:
			return
			
		if ShowAllWindows._app_opening:
			return
			
		if GlobalFunctions.get_time() >= _at:
			for i in _num:
				var window: = Game_Window.new(AppNames.CROW, 170 + randf_range(-30, 30), 
													600 - 60 - 50 + randf_range(-30, 30), true)
				GlobalVars.window_list.add_child(window)
				Stats.window_opened += 1
				Stats.crow_appeared += 1
			_spawned = true
			
func _ready():
	_add_spawn(60 * 3, 1)
	_add_spawn(60 * 5, 2)
	_add_spawn(60 * 7, 2)
	for i in range(9, 100, 2):
		_add_spawn(60 * i, 3)
			
func _process(_delta):
	for spawn in _spawn_list:
		spawn.update()
		
func _add_spawn(at: float, num: float):
	_spawn_list.append(_Spawn.new(at, num))
