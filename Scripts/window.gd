extends Node2D

@onready var window_list: Node2D = get_node("/root/Main/WindowList")

const WINDOW_BORDER_WIDTH: float = 6
const WINDOW_MIN_W: float = 60
const WINDOW_MIN_H: float = 60
const WINDOW_BAR_H: float = 20

var left_border_pressed: bool = false
var top_border_pressed: bool = false
var right_border_pressed: bool = false
var bottom_border_pressed: bool = false
var bar_pressed: bool = false
var content_pressed: bool = false

var window_w: float = 200
var window_h: float = 120

var previous_window_x: float = 0
var previous_window_y: float = 0
var previous_window_w: float = 0
var previous_window_h: float = 0
var previous_mouse_pos: Vector2

func _draw():
	draw_rect(Rect2(1, WINDOW_BAR_H, window_w - 1, window_h - WINDOW_BAR_H), Color(0.79, 0.79, 0.79, 1))
	draw_rect(Rect2(0, 0, window_w, WINDOW_BAR_H), Color(1, 1, 1, 1))
	draw_rect(Rect2(1, WINDOW_BAR_H, window_w - 2, window_h - WINDOW_BAR_H), Color(1, 1, 1, 1), false, 2)
	
func window_ordered_update(_delta: float) -> void:
	border_press_check()
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	
	if Input.is_action_just_pressed("mouse_left"):
		if left_border_pressed or right_border_pressed or top_border_pressed or bottom_border_pressed \
		or bar_pressed:
			previous_window_x = self.position.x
			previous_window_y = self.position.y
			previous_window_w = window_w
			previous_window_h = window_h
			previous_mouse_pos = mouse_pos
			place_window_on_top()
			GlobalFunctions.unfocus_all_desktop_icons()
			
		if content_pressed:
			place_window_on_top()
			GlobalFunctions.unfocus_all_desktop_icons()			

	if left_border_pressed:
		self.position.x = mouse_pos.x
		window_w = previous_window_w + (previous_window_x - mouse_pos.x)
		if window_w < WINDOW_MIN_W:
			window_w = WINDOW_MIN_W
			self.position.x = previous_window_x + previous_window_w - WINDOW_MIN_W
	if right_border_pressed:
		window_w = mouse_pos.x - self.position.x
		if window_w < WINDOW_MIN_W:
			window_w = WINDOW_MIN_W
	if top_border_pressed:
		self.position.y = mouse_pos.y
		window_h = previous_window_h + (previous_window_y - mouse_pos.y)
		if window_h < WINDOW_MIN_H:
			window_h = WINDOW_MIN_H
			self.position.y = previous_window_y + previous_window_h - WINDOW_MIN_H
	if bottom_border_pressed:
		window_h = mouse_pos.y - self.position.y
		if window_h < WINDOW_MIN_H:
			window_h = WINDOW_MIN_H
	
	if bar_pressed:
		self.position.x = previous_window_x + mouse_pos.x - previous_mouse_pos.x
		self.position.y = previous_window_y + mouse_pos.y - previous_mouse_pos.y		
		
	queue_redraw()
		
func border_press_check() -> void:
	if Input.is_action_just_released("mouse_left"):
		top_border_pressed = false
		left_border_pressed = false
		right_border_pressed = false
		bottom_border_pressed = false
		bar_pressed = false
		content_pressed = false

	if GlobalVars.button_press_detected:
		return
		
	var border_pressed: bool = false
		
	if Input.is_action_just_pressed("mouse_left"):
		var mouse_pos: Vector2 = get_global_mouse_position()
		if abs(mouse_pos.x - self.position.x) < WINDOW_BORDER_WIDTH \
		and mouse_pos.y >= self.position.y - WINDOW_BORDER_WIDTH \
		and mouse_pos.y <= self.position.y + window_h + WINDOW_BORDER_WIDTH:
			left_border_pressed = true
			GlobalVars.button_press_detected = true
			border_pressed = true
		
		if abs(mouse_pos.y - self.position.y) < WINDOW_BORDER_WIDTH \
		and mouse_pos.x >= self.position.x - WINDOW_BORDER_WIDTH \
		and mouse_pos.x <= self.position.x + window_w + WINDOW_BORDER_WIDTH:
			top_border_pressed = true
			GlobalVars.button_press_detected = true
			border_pressed = true
			
		if abs(mouse_pos.x - (self.position.x + window_w)) < WINDOW_BORDER_WIDTH \
		and mouse_pos.y >= self.position.y - WINDOW_BORDER_WIDTH \
		and mouse_pos.y <= self.position.y + window_h + WINDOW_BORDER_WIDTH:
			right_border_pressed = true
			GlobalVars.button_press_detected = true
			border_pressed = true
			
		if abs(mouse_pos.y - (self.position.y + window_h)) < WINDOW_BORDER_WIDTH \
		and mouse_pos.x >= self.position.x - WINDOW_BORDER_WIDTH \
		and mouse_pos.x <= self.position.x + window_w + WINDOW_BORDER_WIDTH:
			bottom_border_pressed = true
			GlobalVars.button_press_detected = true
			border_pressed = true
		
		if border_pressed: 
			return
			
		if mouse_pos.y >= self.position.y and mouse_pos.y <= self.position.y + WINDOW_BAR_H \
		and mouse_pos.x >= self.position.x and mouse_pos.x <= self.position.x + window_w:
			bar_pressed = true
			GlobalVars.button_press_detected = true
			return
			
		if mouse_pos.x > self.position.x and mouse_pos.y > self.position.y \
		and mouse_pos.x < self.position.x + window_w and mouse_pos.y < self.position.y + window_h:
			content_pressed = true
			GlobalVars.button_press_detected = true
			return
				
func place_window_on_top() -> void:
	window_list.move_child(self, window_list.get_child_count() - 1)
