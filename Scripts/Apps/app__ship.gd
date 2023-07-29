class_name App_Ship
extends Node2D

var num_of_pots: int = 0
var truck_gone: bool = true

func _init(window: Game_Window):
	_window = window
	
	_window._w = 200
	_window._h = 120
	_window._min_w = 200
	_window._max_w = 200
	_window._min_h = 120
	_window._max_h = 120
	
	_progress_bar = Game_ProgressBar.new(5, 120 - 11, 50, _window._scale)
	_progress_bar.progress_bar_visible = true
	_progress_bar.paused = false
	_progress_bar.fill_time_sec = 90
	_progress_bar.reverse_fill_time_sec = 30
	add_child(_progress_bar)
	
	_drag_window_in = Game_DragWindowIn.new(34, 73, 106/2, 93/2)
	add_child(_drag_window_in)
	
	_text_box = RichTextLabel.new()
	_text_box.theme = _font_theme
	_text_box.scroll_active = false
	_text_box.position.x = 156
	_text_box.position.y = 71
	_text_box.size.x = 110
	_text_box.size.y = 65
	_text_box.text = "x 0"
	_text_box.scale = Vector2(2, 2)
	add_child(_text_box)
	_text_box.hide()
	
	_text_box_2 = RichTextLabel.new()
	_text_box_2.theme = _font_theme
	_text_box_2.scroll_active = false
	_text_box_2.position.x = 10
	_text_box_2.position.y = 20
	_text_box_2.size.x = 200
	_text_box_2.size.y = 65
	_text_box_2.text = "Please wait for the truck"
	_text_box_2.scale = Vector2(2, 2)
	add_child(_text_box_2)
	
func draw_app_content() -> void:
	if not truck_gone:
		_window.draw_texture(_texture__truck, Vector2(5, 15))
	
func update(_delta: float) -> void:
	if _window.scale_transitioning():
		var window_scale = _window.get_window_scale()
		_text_box.scale = Vector2(window_scale, window_scale)
		_text_box.position.x = 156/2 * window_scale
		_text_box.position.y = 71/2 * window_scale
		_text_box_2.scale = Vector2(window_scale, window_scale)
		_text_box_2.position.x = 5 * window_scale
		_text_box_2.position.y = 10 * window_scale
		
	if not truck_gone:
		_drag_window_in.update(_delta)
	_progress_bar.update(_delta)
	
	if _drag_window_in.has_window:
		num_of_pots += 1
		_drag_window_in.has_window = false
		_text_box.text = "x " + str(num_of_pots)
		
	if _progress_bar.progress == 1:
		_progress_bar.reversed = true
		truck_gone = false
		
		_text_box_2.hide()
		_text_box.show()
	elif _progress_bar.progress == 0:
		_progress_bar.reversed = false
		truck_gone = true
		
		_text_box_2.show()
		_text_box.hide()
	
#@onready var _window_list: Node2D = get_node("/root/Main/WindowList")
const _texture__truck: Texture2D = preload("res://Assets/Sprites/Apps/Ship/app__ship__truck.png")
var _font_theme: Theme = preload("res://Assets/Fonts/font.tres")
var _window: Game_Window

var _drag_window_in: Game_DragWindowIn
var _text_box: RichTextLabel
var _text_box_2: RichTextLabel
var _progress_bar: Game_ProgressBar
