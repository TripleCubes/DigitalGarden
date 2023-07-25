extends Node

var _smooth_var_list: = []

func add(smooth_var: SmoothVar) -> void:
	_smooth_var_list.append(smooth_var)

func _process(_delta):
	for smooth_var in _smooth_var_list:
		smooth_var.update()
