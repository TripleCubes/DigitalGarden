class_name App_Seed
extends Node2D

func _init(window: Game_Window):
	_window = window
	
func draw_app_content() -> void:
	_window.draw_texture(_texture__seed__seed_packet, Vector2(5, 10))
	
func update(_delta: float) -> void:
	pass
	
const _texture__seed__seed_packet: Texture2D = preload("res://Assets/Sprites/Apps/Seed/app__seed__seed_packet.png")
var _window: Game_Window
