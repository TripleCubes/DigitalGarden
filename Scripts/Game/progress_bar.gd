class_name Game_ProgressBar
extends Node2D

func _init(x: float, y: float, w: float, scale_ref: SmoothVar):
	_x = x
	_y = y
	_w = w
	_scale_ref = scale_ref
	
func update(_delta) -> void:
	if not progress_bar_visible:
		return
		
	if not paused:
		progress += _delta / fill_time_sec
		if progress > 1:
			progress = 1
	
	queue_redraw()
	
var _texture__left: Texture2D = preload("res://Assets/Sprites/UI/ui__progress_bar__left.png")
var _texture__middle: Texture2D = preload("res://Assets/Sprites/UI/ui__progress_bar__middle.png")
var _texture__right: Texture2D = preload("res://Assets/Sprites/UI/ui__progress_bar__right.png")
var _texture__one_pixel_white: Texture2D = preload("res://Assets/Sprites/UI/ui__one_pixel_white.png")

var _x: float = 0
var _y: float = 0
var _w: float = 0
var color: = Color(1, 1, 1, 1)
var _scale_ref: SmoothVar

var progress: float = 0
var fill_time_sec: float = 10
var paused: bool = true
var progress_bar_visible = false

func _draw():
	if not progress_bar_visible:
		return
		
	draw_set_transform(Vector2(0, 0), 0, Vector2(_scale_ref.get_var(), _scale_ref.get_var()))
	
	draw_texture(_texture__left, Vector2(_x, _y))
	draw_texture_rect(_texture__middle, Rect2(_x + 2, _y, _w - 4, 6), false)
	draw_texture(_texture__right, Vector2(_x + _w - 2, _y))
	draw_texture_rect(_texture__one_pixel_white, Rect2(_x + 2, _y + 2, (_w - 4) * progress, 2), false, color)
