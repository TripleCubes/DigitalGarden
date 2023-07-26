class_name Game_ScrollBar
extends Node2D

const SCROLL_BAR_WIDTH: float = 15
const SCROLL_SPEED: float = 350

func show_scrollbar() -> void:
	_button.show_button()
	_scrollbar_visible = true
	
func hide_scrollbar() -> void:
	_button.hide_button()
	_scrollbar_visible = false
	
func scroll_to_zero() -> void:
	if _horizontal:
		_button.set_button_x(_x)
	else:
		_button.set_button_y(_y)

func get_value() -> float:
	if _horizontal:
		return (_button.get_button_pos().x - _x) / (_length - _button.get_button_size().x)
	else:
		return (_button.get_button_pos().y - _y) / (_length - _button.get_button_size().y)
		
func get_value_pixel() -> float:
	return - get_value() * (_page_size - _visible_size)
	
func set_page_size(page_size: float, visible_size: float) -> void:
	_page_size = page_size
	_visible_size = visible_size
	
	if _horizontal:
		_button.set_button_size(visible_size / page_size * _length, SCROLL_BAR_WIDTH)
	else:
		_button.set_button_size(SCROLL_BAR_WIDTH, visible_size / page_size * _length)
		
func scrolled() -> bool:
	return _scrolled

func _init(x: float, y: float, horizontal: bool, length: float):
	_x = x
	_y = y
	_horizontal = horizontal
	_length = length
	
	if _horizontal:
		_button = Game_Button.new(x, y - SCROLL_BAR_WIDTH, 100, SCROLL_BAR_WIDTH, 1)
	else:
		_button = Game_Button.new(x - SCROLL_BAR_WIDTH, y, SCROLL_BAR_WIDTH, 100, 1)
			
	add_child(_button)
	
var _scrollbar_visible: bool = false

var _button: Game_Button

var _x: float = 0
var _y: float = 0
var _horizontal: bool = false
var _length: float = 0

var _page_size: float = 0
var _visible_size: float = 0

var _scrolled: bool = false

func _draw():
	if not _scrollbar_visible:
		return
		
	if _visible_size > _page_size:
		return
		
	if _horizontal:
		pass
	else:
		draw_rect(Rect2(_x - SCROLL_BAR_WIDTH, _y, SCROLL_BAR_WIDTH, _length), Color(1, 1, 1, 0.7))
		
func update(delta) -> void:
	if not _scrollbar_visible:
		return
		
	if _visible_size > _page_size:
		return
		
	_button.update(delta)
	_scrolled = false
	
	var button_pos = _button.get_button_pos()
	if _horizontal:
		pass
	else:
		if Input.is_action_just_released("SCROLL_UP"):
			_button.set_button_y(button_pos.y - delta * SCROLL_SPEED)
			_scrolled = true
				
		elif Input.is_action_just_released("SCROLL_DOWN"):
			_button.set_button_y(button_pos.y + delta * SCROLL_SPEED)
			_scrolled = true
		
	if _horizontal:
		_button.mouse_drag_x()
		_button.cap_x(_x, _x + _length)
	else:
		_button.mouse_drag_y()
		_button.cap_y(_y, _y + _length)
			
	if _button.pressed():
		_scrolled = true
		
	queue_redraw()
