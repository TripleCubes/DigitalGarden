extends Node2D

@onready var desktop_icon_list = get_node("/root/Main/Desktop")
@export var texture: Texture

const SMOOTH_SCALE_DURATION: float = 300
const SMOOTH_MOVE_DURATION: float = 300

const ICON_WIDTH: float = 40
const DOUBLE_CLICK_TIME = 600

var focused: bool = false

var icon_function: Callable

var icon_scale: float = 1
var previous_icon_scale: float = icon_scale
var destination_icon_scale: float = icon_scale
var start_smooth_scale_at: float = 0

var pressed: bool = false
var just_pressed: bool = false
var double_clicked: bool = false

var previous_x: float = 0
var previous_y: float = 0
var previous_mouse_pos: Vector2

var just_clicked_at: float = 0

func _draw():
	draw_set_transform(Vector2(0, 0), 0, Vector2(icon_scale, icon_scale))
	
	if texture != null:
		draw_texture(texture, Vector2(0, 0))
	else:
		draw_rect(Rect2(0, 0, ICON_WIDTH, ICON_WIDTH), Color(1, 1, 1, 1))
		
	if focused:
		draw_rect(Rect2(1, 1, ICON_WIDTH - 2, ICON_WIDTH - 2), Color(0.57, 0.76, 1), false, 2)

func window_ordered_update(_delta: float) -> void:	
	icon_press_check()
	
	var mouse_pos = get_global_mouse_position()
	
	if just_pressed:
		previous_x = self.position.x
		previous_y = self.position.y
		previous_mouse_pos =mouse_pos
		place_icon_on_top()
		GlobalFunctions.unfocus_all_desktop_icons()
		focused = true
		
	if pressed:
		self.position.x = previous_x +mouse_pos.x - previous_mouse_pos.x
		self.position.y = previous_y +mouse_pos.y - previous_mouse_pos.y
		
	if double_clicked:
		if not icon_function.is_null():
			icon_function.call()
		else:
			print("icon_function is null")
			
	smooth_scale_process()
		
	queue_redraw()
	
func icon_press_check() -> void:
	if Input.is_action_just_released("mouse_left"):
		pressed = false
		
	just_pressed = false
	double_clicked = false
		
	if GlobalVars.button_press_detected:
		return
		
	if Input.is_action_just_pressed("mouse_left"):
		var local_mouse_pos: Vector2 = get_local_mouse_position()
		if local_mouse_pos.x >= 0 and local_mouse_pos.y >= 0 \
		and local_mouse_pos.x <= ICON_WIDTH * icon_scale and local_mouse_pos.y <= ICON_WIDTH * icon_scale:
			pressed = true
			just_pressed = true
			if not double_clicked and Time.get_ticks_msec() - just_clicked_at < DOUBLE_CLICK_TIME:
				double_clicked = true
				just_clicked_at = 0
			else:
				just_clicked_at = Time.get_ticks_msec()
			GlobalVars.button_press_detected = true
	
func place_icon_on_top() -> void:
	desktop_icon_list.move_child(self, desktop_icon_list.get_child_count() - 1)
	
func smooth_scale(scale: float) -> void:
	previous_icon_scale = icon_scale
	destination_icon_scale = scale
	start_smooth_scale_at = Time.get_ticks_msec()
	
func smooth_scale_process() -> void:
	var at: float = (Time.get_ticks_msec() - start_smooth_scale_at) / SMOOTH_SCALE_DURATION
		
	if at > 1:
		icon_scale = destination_icon_scale
		return
		
	icon_scale = lerp(previous_icon_scale, destination_icon_scale, GlobalFunctions.ease_in_out(at))
