extends Node2D

@onready var desktop_icon_list = get_node("/root/Main/Desktop")
@export var texture: Texture

const ICON_WIDTH: float = 40
const DOUBLE_CLICK_TIME = 600

var focused: bool = false

var icon_function: Callable

var pressed: bool = false
var just_pressed: bool = false
var double_clicked: bool = false

var previous_x: float = 0
var previous_y: float = 0
var previous_mouse_pos: Vector2

var just_clicked_at: float = 0

func _draw():
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
		and local_mouse_pos.x <= ICON_WIDTH and local_mouse_pos.y <= ICON_WIDTH:
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
