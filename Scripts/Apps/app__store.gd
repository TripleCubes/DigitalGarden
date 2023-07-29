class_name App_Store
extends Node2D

func _init(window: Game_Window):
	_window = window
	
	_window._w = 120
	_window._h = 170
	_window._min_w = 120
	_window._max_w = 120
	_window._min_h = 170
	_window._max_h = 170
	
	_download_ram = StoreDownload.new(15, preload("res://Assets/Sprites/Apps/Store/app__store__download__ram.png"),
						"More RAM", 10, _window._scale)
	add_child(_download_ram)
	
func draw_app_content() -> void:
	pass
	
func update(_delta: float) -> void:
	_download_ram.update(_delta)
	
#@onready var _window_list: Node2D = get_node("/root/Main/WindowList")
#const _texture__: Texture2D = preload("res://Assets/Sprites/Apps/")
var _window: Game_Window

var _download_ram: StoreDownload
