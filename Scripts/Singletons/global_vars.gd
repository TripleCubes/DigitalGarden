extends Node

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

var show_debug_informations: bool = false
