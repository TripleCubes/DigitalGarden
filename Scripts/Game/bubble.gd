class_name Game_Bubble
extends Node2D

enum PointyDir {
	TOP_LEFT,
	TOP_RIGHT,
	BOTTOM_LEFT,
	BOTTOM_RIGHT,
}

var bubble_visible: bool = false
var icon: Texture2D = null

func _init(x: float, y: float, w: float, h: float, pointy_dir: PointyDir, scale_ref: SmoothVar):
	_x = x
	_y = y
	_w = w
	_h = h
	_pointy_dir = pointy_dir
	_scale_ref = scale_ref
	
func update(_delta):
	queue_redraw()
	
var _texture__top_left: Texture2D = preload("res://Assets/Sprites/UI/ui__text_bubble__top_left.png")
var _texture__top_right: Texture2D = preload("res://Assets/Sprites/UI/ui__text_bubble__top_right.png")
var _texture__bottom_left: Texture2D = preload("res://Assets/Sprites/UI/ui__text_bubble__bottom_left.png")
var _texture__bottom_right: Texture2D = preload("res://Assets/Sprites/UI/ui__text_bubble__bottom_right.png")

var _texture__top_left__pointy: Texture2D = preload("res://Assets/Sprites/UI/ui__text_bubble__top_left__pointy.png")
var _texture__top_right__pointy: Texture2D = preload("res://Assets/Sprites/UI/ui__text_bubble__top_right__pointy.png")
var _texture__bottom_left__pointy: Texture2D = preload("res://Assets/Sprites/UI/ui__text_bubble__bottom_left__pointy.png")
var _texture__bottom_right__pointy: Texture2D = preload("res://Assets/Sprites/UI/ui__text_bubble__bottom_right__pointy.png")

var _texture__top: Texture2D = preload("res://Assets/Sprites/UI/ui__text_bubble__top.png")
var _texture__bottom: Texture2D = preload("res://Assets/Sprites/UI/ui__text_bubble__bottom.png")
var _texture__left: Texture2D = preload("res://Assets/Sprites/UI/ui__text_bubble__left.png")
var _texture__right: Texture2D = preload("res://Assets/Sprites/UI/ui__text_bubble__right.png")

var _texture__brown_pixel: Texture2D = preload("res://Assets/Sprites/UI/ui__one_pixel_brown.png")

var _x: float = 0
var _y: float = 0
var _w: float = 0
var _h: float = 0
var _pointy_dir: PointyDir = 0
var _scale_ref: SmoothVar

func _draw():
	if not bubble_visible: 
		return
		
	draw_set_transform(Vector2(0, 0), 0, Vector2(_scale_ref.get_var(), _scale_ref.get_var()))
	
	if _pointy_dir == PointyDir.TOP_LEFT:
		draw_texture(_texture__top_left__pointy, Vector2(_x, _y))
	else:
		draw_texture(_texture__top_left, Vector2(_x, _y))
		
	if _pointy_dir == PointyDir.TOP_RIGHT:
		draw_texture(_texture__top_right__pointy, Vector2(_x + _w - 3, _y))
	else:
		draw_texture(_texture__top_right, Vector2(_x + _w - 3, _y))
		
	if _pointy_dir == PointyDir.BOTTOM_LEFT:
		draw_texture(_texture__bottom_left__pointy, Vector2(_x, _y + _h - 3))
	else:
		draw_texture(_texture__bottom_left, Vector2(_x, _y + _h - 3))
		
	if _pointy_dir == PointyDir.BOTTOM_RIGHT:
		draw_texture(_texture__bottom_right__pointy, Vector2(_x + _w - 3, _y + _h - 3))
	else:
		draw_texture(_texture__bottom_right, Vector2(_x + _w - 3, _y + _h - 3))
		
	draw_texture_rect(_texture__top, Rect2(_x + 3, _y, _w - 6, 3), false)
	draw_texture_rect(_texture__bottom, Rect2(_x + 3, _y + _h - 3, _w - 6, 3), false)
	draw_texture_rect(_texture__left, Rect2(_x, _y + 3, 3, _h - 6), false)
	draw_texture_rect(_texture__right, Rect2(_x + _w - 3, _y + 3, 3, _h - 6), false)
	
	draw_texture_rect(_texture__brown_pixel, Rect2(_x + 3, _y + 3, _w - 6, _h - 6), false)
	
	if icon != null:
		draw_texture(icon, Vector2(_x + 3, _y + 3))
