class_name StoreDownload
extends Node2D

const _texture_download: Texture2D = preload("res://Assets/Sprites/Apps/Store/app__store__download.png")

var _icon: Texture2D
var _y: float = 0
var _text: String
var _required_tasks: int = 0
var _label: RichTextLabel
var _label_tasks: RichTextLabel

var _button: Game_Button
var _scale_ref: SmoothVar

func _init(y: float, icon: Texture2D, text: String, required_tasks: int, scale_ref: SmoothVar):
	_icon = icon
	_text = text
	_y = y
	_required_tasks = required_tasks
	_scale_ref = scale_ref
	
	_label = RichTextLabel.new()
	GlobalFunctions.setup_label(_label, 60, y + 10, text)
	add_child(_label)
	
	_label_tasks = RichTextLabel.new()
	GlobalFunctions.setup_label(_label_tasks, 60, y + 35)
	add_child(_label_tasks)
	
	_button = Game_Button.new(190, y + 20, 35, 35, 1, Color(0, 0, 0, 0))
	add_child(_button)
	
func _draw():
	draw_set_transform(Vector2(0, 0), 0, Vector2(_scale_ref.get_var(), _scale_ref.get_var()))
	if _required_tasks - Stats.tasks_finished <= 0:
		draw_texture(_texture_download, Vector2(190/2, _y + 3))
	draw_texture(_icon, Vector2(5, _y))
	
func update(_delta):
	_button.update(_delta)
	
	if _required_tasks - Stats.tasks_finished <= 0:
		_label_tasks.text = ""
		_button.show_button()
	else:
		_label_tasks.text = str(_required_tasks - Stats.tasks_finished) + " more tasks"
	
	if _scale_ref.transitioning():
		_label.scale = Vector2(_scale_ref.get_var(), _scale_ref.get_var())
		_label.position.x = 60 * _scale_ref.get_var()/2
		_label.position.y = (_y+10) * _scale_ref.get_var()/2
		
		_label_tasks.scale = Vector2(_scale_ref.get_var(), _scale_ref.get_var())
		_label_tasks.position.x = 60 * _scale_ref.get_var()/2
		_label_tasks.position.y = (_y+35) * _scale_ref.get_var()/2
	
	queue_redraw()
