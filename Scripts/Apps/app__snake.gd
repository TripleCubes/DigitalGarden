class_name App_Snake
extends Node2D

const WINDOW_W: float = 39
const WINDOW_H: float = 29
const PADDING_LEFT: float = 5
const PADDING_TOP: float = 15
const SNAKE_SPEED: float = 10

#@onready var _window_list: Node2D = get_node("/root/Main/WindowList")
const _texture__dot: Texture2D = preload("res://Assets/Sprites/UI/ui__one_pixel_yellow.png")
const _texture__dot_yellow: Texture2D = preload("res://Assets/Sprites/UI/ui__one_pixel_yellow_yellow.png")
const _texture__controls: Texture2D = preload("res://Assets/Sprites/Apps/Snake/app__snake__controls.png")
const _texture__score: Texture2D = preload("res://Assets/Sprites/Apps/Snake/app__snake__score.png")
const _font: Font = preload("res://Assets/Fonts/Munro/munro.ttf")
var _window: Game_Window

var _up_btn: Game_Button
var _down_btn: Game_Button
var _left_btn: Game_Button
var _right_btn: Game_Button

var _snake: = []
enum _Dir {
	UP,
	DOWN,
	LEFT,
	RIGHT,
}
var _dir: = _Dir.RIGHT
var _apple_pos: Vector2i
var _snake_pos: = Vector2(10, 10)
var _snake_previous_pos_i: Vector2i

func _init(window: Game_Window):
	_window = window
	
	_window._w = 90
	_window._h = 130
	_window._min_w = 90
	_window._max_w = 90
	_window._min_h = 130
	_window._max_h = 130
	
	_up_btn = Game_Button.new(46, 160, 15, 15, 2, Color(0, 0, 0, 0))
	add_child(_up_btn)
	_up_btn.show_button()
	
	_down_btn = Game_Button.new(46, 190, 15, 15, 2, Color(0, 0, 0, 0))
	add_child(_down_btn)
	_down_btn.show_button()
	
	_left_btn = Game_Button.new(16, 190, 15, 15, 2, Color(0, 0, 0, 0))
	add_child(_left_btn)
	_left_btn.show_button()
	
	_right_btn = Game_Button.new(76, 190, 15, 15, 2, Color(0, 0, 0, 0))
	add_child(_right_btn)
	_right_btn.show_button()
	
	_snake_previous_pos_i = Vector2i(_snake_x(), _snake_y())
	_snake.append(Vector2i(_snake_x() - 3, _snake_y()))
	_snake.append(Vector2i(_snake_x() - 2, _snake_y()))
	_snake.append(Vector2i(_snake_x() - 1, _snake_y()))
	_snake.append(Vector2i(_snake_x(), _snake_y()))
	_reroll_apple_pos()
	
func draw_app_content() -> void:
	_line(1, 0, WINDOW_W*2, 1)
	_line(1 , WINDOW_H*2 + 1, WINDOW_W*2, 1)
	_line(0, 1, 1, WINDOW_H*2)
	_line(WINDOW_W*2 + 1, 1, 1, WINDOW_H*2)
	_window.draw_texture(_texture__controls, Vector2(7.5, 15 + WINDOW_H*2+6.5))
	
	_pixel_2_yellow(_apple_pos.x, _apple_pos.y)
	_pixel_2(_snake_pos.x, _snake_pos.y)
	for pixel in _snake:
		_pixel_2(pixel.x, pixel.y)
		
	_window.draw_texture(_texture__score, Vector2(7.5 + 50, 15 + WINDOW_H*2+6.5))
	_window.draw_string(_font, Vector2(7.5 + 55, 15 + WINDOW_H*2+6.5 + 11), str(_snake.size()),
							HORIZONTAL_ALIGNMENT_LEFT, 100, 10, GlobalConsts.COLOR_YELLOW)
	
func update(_delta: float) -> void:
	_up_btn.update(_delta)
	_down_btn.update(_delta)
	_left_btn.update(_delta)
	_right_btn.update(_delta)
	
	if _dir != _Dir.DOWN and (_up_btn.just_pressed() or Input.is_action_just_pressed("KEY_UP")):
		_dir = _Dir.UP
	if _dir != _Dir.UP and (_down_btn.just_pressed() or Input.is_action_just_pressed("KEY_DOWN")):
		_dir = _Dir.DOWN
	if _dir != _Dir.RIGHT and (_left_btn.just_pressed() or Input.is_action_just_pressed("KEY_LEFT")):
		_dir = _Dir.LEFT
	if _dir != _Dir.LEFT and (_right_btn.just_pressed() or Input.is_action_just_pressed("KEY_RIGHT")):
		_dir = _Dir.RIGHT
		
	if _dir == _Dir.UP:
		_snake_pos.y -= _delta * SNAKE_SPEED
	elif _dir == _Dir.DOWN:
		_snake_pos.y += _delta * SNAKE_SPEED
	elif _dir == _Dir.LEFT:
		_snake_pos.x -= _delta * SNAKE_SPEED
	elif _dir == _Dir.RIGHT:
		_snake_pos.x += _delta * SNAKE_SPEED
		
	if _snake_x() < 0:
		_snake_pos.x = WINDOW_W - _snake_pos.x - 2
	elif _snake_x() > WINDOW_W - 1:
		_snake_pos.x = _snake_pos.x - (WINDOW_W)
		
	if _snake_y() < 0:
		_snake_pos.y = WINDOW_H - _snake_pos.y - 2
	elif _snake_y() > WINDOW_H - 1:
		_snake_pos.y = _snake_pos.y - (WINDOW_H)
		
	var dont_remove: bool = false
	if _snake_x() == _apple_pos.x and _snake_y() == _apple_pos.y:
		dont_remove = true
		_reroll_apple_pos()
		
	_snake_bite_itself_check()
		
	var moved: bool = false
	if _snake_x() != _snake_previous_pos_i.x or _snake_y() != _snake_previous_pos_i.y:
		_snake_previous_pos_i = Vector2i(_snake_x(), _snake_y())
		moved = true
		
	if moved:
		if not dont_remove:
			_snake.remove_at(0)
		_snake.append(Vector2i(_snake_x(), _snake_y()))

func _line(x: float, y: float, w: float, h: float) -> void:
	_window.draw_texture_rect(_texture__dot, Rect2(PADDING_LEFT + x, PADDING_TOP + y, w, h), false)
	
func _pixel_2(x: float, y: float) -> void:
	_window.draw_texture_rect(_texture__dot, Rect2(PADDING_LEFT+1 + round(x)*2, PADDING_TOP+1 + round(y)*2, 2, 2), false)
	
func _pixel_2_yellow(x: float, y: float) -> void:
	_window.draw_texture_rect(_texture__dot_yellow, Rect2(PADDING_LEFT+1 + round(x)*2, PADDING_TOP+1 + round(y)*2, 2, 2), false)
	
func _snake_x() -> int:
	return round(_snake_pos.x)
	
func _snake_y() -> int:
	return round(_snake_pos.y)
	
func _reroll_apple_pos() -> void:
	while true:
		_apple_pos = Vector2i(randi_range(0, WINDOW_W - 1), randi_range(0, WINDOW_H - 1))
		if _apple_pos.x == _snake_x() and _apple_pos.y == _snake_y():
			continue
		for pixel in _snake:
			if _apple_pos.x == pixel.x and _apple_pos.y == pixel.y:
				continue
		break
		
func _snake_bite_itself_check() -> void:
	for i in _snake.size() - 1:
		var pixel: Vector2i = _snake[i]
		if _snake_x() == pixel.x and _snake_y() == pixel.y:
			_restart_game()
			break
			
func _restart_game() -> void:
	_dir = _Dir.RIGHT
	_snake_pos = Vector2(10, 10)
	_snake_previous_pos_i = Vector2i(_snake_x(), _snake_y())
	_snake.clear()
	_snake.append(Vector2i(_snake_x() - 3, _snake_y()))
	_snake.append(Vector2i(_snake_x() - 2, _snake_y()))
	_snake.append(Vector2i(_snake_x() - 1, _snake_y()))
	_snake.append(Vector2i(_snake_x(), _snake_y()))
	_reroll_apple_pos()
