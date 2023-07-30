class_name App_Stats
extends Node2D

func _init(window: Game_Window):
	_window = window
	
	_window._w = 120
	_window._h = 140
	_window._min_w = 120
	_window._max_w = 120
	_window._min_h = 140
	_window._max_h = 140
	
	for i in 8:
		_label_list.append(RichTextLabel.new())
		setup_label(_label_list[_label_list.size() - 1], 10, 25 + (_label_list.size()-1) * 30)
	
func draw_app_content() -> void:
	pass
	
func update(_delta: float) -> void:
	_label_list[0].text = "RAM: " + str(Stats.get_current_ram()) + "/" + str(Stats.max_ram)
	_label_list[1].text = "Flowers shipped: " + str(Stats.flowers_shipped)
	_label_list[2].text = "Flowers dead: " + str(Stats.flowers_dead)
	_label_list[3].text = "Flowers grown: " + str(Stats.flowers_grown)
	_label_list[4].text = "Watering can filled: " + str(Stats.watering_can_filled)
	_label_list[5].text = "Seed planted: " + str(Stats.seed_planted)
	_label_list[6].text = "Window opened: " + str(Stats.window_opened)
	_label_list[7].text = "Tree watered: " + str(1)
	
	if _window.scale_transitioning():
		var window_scale = _window.get_window_scale()
		for i in _label_list.size():
			_label_list[i].scale = Vector2(window_scale, window_scale)
			_label_list[i].position.x = 5 * window_scale
			_label_list[i].position.y = (25 + i * 30)/2 * window_scale
	
#@onready var _window_list: Node2D = get_node("/root/Main/WindowList")
#const _texture__: Texture2D = preload("res://Assets/Sprites/Apps/")
var _font_theme: Theme = preload("res://Assets/Fonts/font.tres")
var _window: Game_Window

var _label_list: = []

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
