class_name Game_Task
extends Node2D

var _icon: Texture2D
var _y: float = 0
var _text: String
var _sub_text: String
var _label: RichTextLabel
var _label_sub_text: RichTextLabel
var _task_func: Callable
var _sub_text_func

var _scale_ref: SmoothVar

func _init(y: float, icon: Texture2D, text: String, sub_text_func: Callable, 
				scale_ref: SmoothVar, task_func: Callable):
	_icon = icon
	_text = text
	_y = y
	_sub_text_func = sub_text_func
	_scale_ref = scale_ref
	_task_func = task_func
	
	_label = RichTextLabel.new()
	GlobalFunctions.setup_label(_label, 60, y * 2 - 4, text)
	add_child(_label)
	
	_label_sub_text = RichTextLabel.new()
	GlobalFunctions.setup_label(_label_sub_text, 60, y * 2 + 19)
	add_child(_label_sub_text)
	
func _draw():
	draw_set_transform(Vector2(0, 0), 0, Vector2(_scale_ref.get_var(), _scale_ref.get_var()))
	draw_texture(_icon, Vector2(5, _y))
	
func update(_delta):
	if _task_func.call():
		_label_sub_text.text = "Done"
	else:
		_label_sub_text.text = _sub_text_func.call()
	
	if _scale_ref.transitioning():
		_label.scale = Vector2(_scale_ref.get_var(), _scale_ref.get_var())
		_label.position.x = 60 * _scale_ref.get_var()/2
		_label.position.y = (_y*2 - 4) * _scale_ref.get_var()/2
		
		_label_sub_text.scale = Vector2(_scale_ref.get_var(), _scale_ref.get_var())
		_label_sub_text.position.x = 60 * _scale_ref.get_var()/2
		_label_sub_text.position.y = (_y*2+19) * _scale_ref.get_var()/2
	
	queue_redraw()
