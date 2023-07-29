class_name App_Stats
extends Node2D

func _init(window: Game_Window):
	_window = window
	
	_window._w = 120
	_window._h = 170
	_window._min_w = 120
	_window._max_w = 120
	_window._min_h = 170
	_window._max_h = 170
	
	_text_ram = RichTextLabel.new()
	setup_label(_text_ram, 10, 25)
	
func draw_app_content() -> void:
	pass
	
func update(_delta: float) -> void:
	_text_ram.text = "RAM: " + str(Stats.get_current_ram()) + "/" + str(Stats.max_ram)
	
	if _window.scale_transitioning():
		var window_scale = _window.get_window_scale()
		_text_ram.scale = Vector2(window_scale, window_scale)
		_text_ram.position.x = 5 * window_scale
		_text_ram.position.y = 25/2 * window_scale
	
#@onready var _window_list: Node2D = get_node("/root/Main/WindowList")
#const _texture__: Texture2D = preload("res://Assets/Sprites/Apps/")
var _font_theme: Theme = preload("res://Assets/Fonts/font.tres")
var _window: Game_Window

var _text_ram: RichTextLabel

func setup_label(label: RichTextLabel, x: float, y: float, init_text: String = "") -> void:
	label.theme = _font_theme
	label.scroll_active = false
	label.position.x = x
	label.position.y = y
	label.size.x = 110
	label.size.y = 65
	label.text = init_text
	label.scale = Vector2(2, 2)
	add_child(label)
