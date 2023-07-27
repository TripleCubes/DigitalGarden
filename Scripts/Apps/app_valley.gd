class_name App_Valley
extends Node2D

func _init(window: Game_Window):
	_window = window
	
	_text_box = RichTextLabel.new()
	_text_box.theme = _font_theme
	_text_box.scroll_active = false
	_text_box.position.x = 160
	_text_box.position.y = 30
	_text_box.size.x = 110
	_text_box.size.y = 65
	_text_box.text = "This is a test This is a test This is a test This is a test This is a test \
						This is a test This is a test This is a test This is a test This is a test  \
						This is a test This is a test This is a test This is a test This is a test "
	_text_box.scale = Vector2(2, 2)
	add_child(_text_box)
	
func draw_app_content() -> void:
	_window.draw_texture(_texture__valley_o, Vector2(5, 15))
	
func update(_delta: float) -> void:
	if _window.scale_transitioning():
		var window_scale = _window.get_window_scale()
		_text_box.scale = Vector2(window_scale, window_scale)
		_text_box.position.x = 80 * window_scale
		_text_box.position.y = 15 * window_scale
	
const _texture__valley_o: Texture2D = preload("res://Assets/Sprites/Apps/Valley/app__valley__o.png")
var _font_theme: Theme = preload("res://Assets/Fonts/font.tres")
var _text_box: RichTextLabel
var _window: Game_Window
