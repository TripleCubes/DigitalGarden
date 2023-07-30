extends Node

@onready var window_list: Node2D = get_node("/root/Main/WindowList")

var game_start_at: float = 0

var button_press_detected: bool = false
var window_hover_detected: bool = false

enum CursorShape {
	POINTER,
	TOP_DOWN,
	LEFT_RIGHT,
	FORWARD_DIAGONAL,
	DOWNWARD_DIAGONAL,
}
var decided_cursor_shape: CursorShape = CursorShape.POINTER

var valley_icon: Game_DesktopIcon
var valley_app: App_Valley

var valley_opened: bool = false

var show_debug_informations: bool = false
