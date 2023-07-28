class_name Game_TextBubble
extends Node2D

const TEXT_COOL_DOWN: float = 12 # Secs

func _init(x: float, y: float, pointy_dir: Game_Bubble.PointyDir, scale_ref: SmoothVar):
	_bubble = Game_Bubble.new(x, y, 10, 10, pointy_dir, scale_ref)
	add_child(_bubble)
	
	_text_box = RichTextLabel.new()
	_text_box.theme = _font_theme
	_text_box.scroll_active = false
	_text_box.position.x = x * 2 + 10
	_text_box.position.y = y * 2 + 5
	_text_box.text = ""
	_text_box.scale = Vector2(2, 2)
	add_child(_text_box)
	_text_box.hide()
	
func show_text(text: String, w: float):
	var text_size: = _font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, w, 10)
	if text_size.x < w:
		w = text_size.x
	_text_box.text = text
	_text_box.size.x = w
	_text_box.size.y = text_size.y
	_bubble._w = w + 10
	_bubble._h = text_size.y + 5
	
	_text_box.show()
	_bubble.bubble_visible = true
	
	_text_start_at = Time.get_ticks_msec()
	
func set_pos(x: float, y: float) -> void:
	_text_box.position.x = x * 2 + 10
	_text_box.position.y = y * 2 + 5
	_bubble._x = x
	_bubble._y = y
	
var _font_theme: Theme = preload("res://Assets/Fonts/font.tres")
var _font: Font = preload("res://Assets/Fonts/Munro/munro.ttf")
var _text_box: RichTextLabel
var _bubble: Game_Bubble

var _text_start_at: float = 0
	
func update(_delta):
	_bubble.update(_delta)
	
	if Time.get_ticks_msec() - _text_start_at > TEXT_COOL_DOWN * 1000:
		_text_box.hide()
		_bubble.bubble_visible = false

func _draw():
	pass
