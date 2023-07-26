class_name SmoothVar

func _init(num: float):
	set_var(num)
	SmoothVarUpdater.add(self)
	
func set_var(num: float) -> void:
	_var = num
	_previous = num
	_destination = num
	
func set_destination(num: float) -> void:
	_previous = _var
	_destination = num
	_smooth_transition_start_at = Time.get_ticks_msec()

func get_var() -> float:
	return _var
	
func get_destination() -> float:
	return _destination
	
func transitioning() -> bool:
	return _var != _destination
	
func update():
	var at: float = (Time.get_ticks_msec() - _smooth_transition_start_at) / _smooth_transition_duration
	
	if at > 1:
		_var = _destination
		return
		
	_var = lerp(_previous, _destination, GlobalFunctions.ease_in_out(at))
	
var _var: float = 0
var _previous: float = 0
var _destination: float = 0
var _smooth_transition_start_at: float = 0
var _smooth_transition_duration: float = 300
