class_name App_Valley
extends Node2D

func _init(window: Game_Window):
	_window = window
	
	_window._w = 200
	_window._h = 90
	_window._min_w = 200
	_window._max_w = 200
	_window._min_h = 90
	_window._max_h = 90
	
	_text_box = RichTextLabel.new()
	_text_box.theme = _font_theme
	_text_box.scroll_active = false
	_text_box.position.x = 160
	_text_box.position.y = 30
	_text_box.size.x = 110
	_text_box.size.y = 65
	_text_box.scale = Vector2(2, 2)
	add_child(_text_box)
	
func dialogue(text: String, icon: Texture2D) -> void:
	_text_bubble.hide_text()
	
	if _window.get_parent() != _window_list:
		_text_bubble.show_text(text, 100)
		GlobalFunctions.place_valley_icon_on_top()
		
	_text_box.text = text
	
func draw_app_content() -> void:
	_window.draw_texture(_texture__valley_o, Vector2(5, 15))
	
func update(_delta: float) -> void:
	if _text_bubble == null:
		_text_bubble = Game_TextBubble.new(150, 150, Game_Bubble.PointyDir.TOP_LEFT, _window._scale)
		GlobalVars.valley_icon.add_child(_text_bubble)
	
	if _window.scale_transitioning():
		var window_scale = _window.get_window_scale()
		_text_box.scale = Vector2(window_scale, window_scale)
		_text_box.position.x = 80 * window_scale
		_text_box.position.y = 15 * window_scale
		
	_text_bubble.set_pos(GlobalVars.valley_icon.get_pos().x / 2 + 25, GlobalVars.valley_icon.get_pos().y / 2)
	_text_bubble.update(_delta)
	
@onready var _window_list: Node2D = get_node("/root/Main/WindowList")
const _texture__valley_o: Texture2D = preload("res://Assets/Sprites/Apps/Valley/app__valley__o.png")
var _font_theme: Theme = preload("res://Assets/Fonts/font.tres")
var _text_box: RichTextLabel
var _window: Game_Window

var _text_bubble: Game_TextBubble = null
