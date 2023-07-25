extends Node2D

@onready var window_list: Node2D = get_node("/root/Main/WindowList")

const WINDOW_BORDER_WIDTH: float = 1
const WINDOW_BORDER_PRESS_DETECTION_WIDTH: float = 6
const WINDOW_MIN_W: float = 60
const WINDOW_MIN_H: float = 60
const WINDOW_BAR_H: float = 10

const SMOOTH_SCALE_DURATION: float = 300
const SMOOTH_MOVE_DURATION: float = 300

var window_scale: float = 2
var smooth_scale_previous: float = window_scale
var smooth_scale_destination: float = window_scale
var smooth_scale_start_at: float = 0

var left_border_pressed: bool = false
var top_border_pressed: bool = false
var right_border_pressed: bool = false
var bottom_border_pressed: bool = false
var bar_pressed: bool = false
var content_pressed: bool = false

var window_w: float = 100
var window_h: float = 60

var previous_window_x: float = 0
var previous_window_y: float = 0
var previous_window_w: float = 0
var previous_window_h: float = 0
var previous_mouse_pos: Vector2

@onready var smooth_move_previous_x: float = self.position.x
@onready var smooth_move_previous_y: float = self.position.y
@onready var smooth_move_destination_x: float = self.position.x
@onready var smooth_move_destination_y: float = self.position.y
var smooth_move_start_at: float = 0

func _draw():
	draw_set_transform(Vector2(0, 0), 0, Vector2(window_scale, window_scale))

	draw_rect(Rect2(WINDOW_BORDER_WIDTH/2, WINDOW_BAR_H,
					window_w - WINDOW_BORDER_WIDTH/2, 
					window_h - WINDOW_BAR_H),
					Color(0.79, 0.79, 0.79, 1))
	draw_rect(Rect2(0, 0, window_w, WINDOW_BAR_H), Color(1, 1, 1, 1))
	draw_rect(Rect2(WINDOW_BORDER_WIDTH/2, WINDOW_BAR_H, 
					window_w - WINDOW_BORDER_WIDTH, 
					window_h - WINDOW_BAR_H), 
					Color(1, 1, 1, 1), false, WINDOW_BORDER_WIDTH)
	
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
		move_x(mouse_pos.x)
		window_w = (previous_window_w * window_scale + (previous_window_x - mouse_pos.x)) / window_scale
		if window_w < WINDOW_MIN_W:
			window_w = WINDOW_MIN_W
			move_x(previous_window_x + (previous_window_w - WINDOW_MIN_W) * window_scale)
	if right_border_pressed:
		window_w = (mouse_pos.x - self.position.x) / window_scale
		if window_w < WINDOW_MIN_W:
			window_w = WINDOW_MIN_W
	if top_border_pressed:
		move_y(mouse_pos.y)
		window_h = (previous_window_h * window_scale + (previous_window_y - mouse_pos.y)) / window_scale
		if window_h < WINDOW_MIN_H:
			window_h = WINDOW_MIN_H
			move_y(previous_window_y + (previous_window_h - WINDOW_MIN_H) * window_scale)
	if bottom_border_pressed:
		window_h = (mouse_pos.y - self.position.y) / window_scale
		if window_h < WINDOW_MIN_H:
			window_h = WINDOW_MIN_H
	
	if bar_pressed:
		move(previous_window_x + mouse_pos.x - previous_mouse_pos.x,
				previous_window_y + mouse_pos.y - previous_mouse_pos.y)
		
	smooth_scale_process()
	smooth_move_process()
		
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
		if abs(mouse_pos.x - self.position.x) < WINDOW_BORDER_PRESS_DETECTION_WIDTH \
		and mouse_pos.y >= self.position.y - WINDOW_BORDER_PRESS_DETECTION_WIDTH \
		and mouse_pos.y <= self.position.y + (window_h + WINDOW_BORDER_WIDTH) * window_scale:
			left_border_pressed = true
			GlobalVars.button_press_detected = true
			border_pressed = true
		
		if abs(mouse_pos.y - self.position.y) < WINDOW_BORDER_PRESS_DETECTION_WIDTH \
		and mouse_pos.x >= self.position.x - WINDOW_BORDER_PRESS_DETECTION_WIDTH \
		and mouse_pos.x <= self.position.x + (window_w + WINDOW_BORDER_WIDTH) * window_scale:
			top_border_pressed = true
			GlobalVars.button_press_detected = true
			border_pressed = true
			
		if abs(mouse_pos.x - (self.position.x + window_w * window_scale)) < WINDOW_BORDER_PRESS_DETECTION_WIDTH \
		and mouse_pos.y >= self.position.y - WINDOW_BORDER_PRESS_DETECTION_WIDTH \
		and mouse_pos.y <= self.position.y + (window_h + WINDOW_BORDER_WIDTH) * window_scale:
			right_border_pressed = true
			GlobalVars.button_press_detected = true
			border_pressed = true
			
		if abs(mouse_pos.y - (self.position.y + window_h * window_scale)) < WINDOW_BORDER_PRESS_DETECTION_WIDTH \
		and mouse_pos.x >= self.position.x - WINDOW_BORDER_PRESS_DETECTION_WIDTH \
		and mouse_pos.x <= self.position.x + (window_w + WINDOW_BORDER_WIDTH) * window_scale:
			bottom_border_pressed = true
			GlobalVars.button_press_detected = true
			border_pressed = true
		
		if border_pressed: 
			return
			
		if mouse_pos.y >= self.position.y and mouse_pos.y <= self.position.y + WINDOW_BAR_H * window_scale \
		and mouse_pos.x >= self.position.x and mouse_pos.x <= self.position.x + window_w * window_scale:
			bar_pressed = true
			GlobalVars.button_press_detected = true
			return
			
		if mouse_pos.x > self.position.x and mouse_pos.y > self.position.y \
		and mouse_pos.x < self.position.x + window_w * window_scale \
		and mouse_pos.y < self.position.y + window_h * window_scale:
			content_pressed = true
			GlobalVars.button_press_detected = true
			return
				
func place_window_on_top() -> void:
	window_list.move_child(self, window_list.get_child_count() - 1)
	
func smooth_scale(scale: float) -> void:
	smooth_scale_previous = window_scale
	smooth_scale_destination = scale
	smooth_scale_start_at = Time.get_ticks_msec()
	
func smooth_scale_process() -> void:
	var at: float = (Time.get_ticks_msec() - smooth_scale_start_at) / SMOOTH_SCALE_DURATION
	
	if at > 1:
		window_scale = smooth_scale_destination
		return
		
	window_scale = lerp(smooth_scale_previous, smooth_scale_destination, GlobalFunctions.ease_in_out(at))

func move_x(x: float) -> void:
	smooth_move_previous_x = x
	smooth_move_destination_x = x
	self.position.x = x
	
func move_y(y: float) -> void:
	smooth_move_previous_y = y
	smooth_move_destination_y = y
	self.position.y = y
	
func move(x: float, y: float) -> void:
	move_x(x)
	move_y(y)
	
func smooth_move(x: float, y: float) -> void:
	smooth_move_previous_x = self.position.x
	smooth_move_previous_y = self.position.y
	smooth_move_destination_x = x
	smooth_move_destination_y = y
	smooth_move_start_at = Time.get_ticks_msec()
	
func smooth_move_process() -> void:
	var at: float = (Time.get_ticks_msec() - smooth_move_start_at) / SMOOTH_SCALE_DURATION
	
	if at > 1:
		self.position.x = smooth_move_destination_x
		self.position.y = smooth_move_destination_y
		return
		
	self.position.x = lerp(smooth_move_previous_x, smooth_move_destination_x, GlobalFunctions.ease_in_out(at))
	self.position.y = lerp(smooth_move_previous_y, smooth_move_destination_y, GlobalFunctions.ease_in_out(at))	
