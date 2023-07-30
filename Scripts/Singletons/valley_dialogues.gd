extends Node

var dialogue_list: = []

class _Dialogue:
	var id: String
	var text: String
	var icon: Texture2D
	
	var called: bool = false
	
	func _init(id: String, text: String, icon: Texture2D = null):
		self.id = id
		self.text = text
		self.icon = icon
		
	func dialogue() -> void:
		if called:
			return
			
		called = true
		GlobalVars.valley_app.dialogue(text, icon)

func _ready():
	_add_dialogue("Click me", "Heeeeey, can you double click me?")
	_add_dialogue("Hi", "Hi! Im Valley. Im living rent free in your desktop")
	_add_dialogue("Drag", "That is a pot, you can drag seed into it")
	_add_dialogue("Dont waste water", "Hey, dont waste water")
	_add_dialogue("Dont close me", "Heeeeey, dont close me, I run in background, you wont get any RAM back")
	_add_dialogue("Out of RAM", "You are out of RAM. Maybe close some windows?")
	_add_dialogue("Crow", "Oh, a crow")
			
func _process(delta):
	if not GlobalVars.valley_opened and get_time() > 3:
		_dialogue("Click me")
		
	if GlobalVars.valley_opened:
		_dialogue("Hi")
		
	if Stats.pot_opened >= 1:
		_dialogue("Drag")
		
	if Stats.water_dispensed:
		_dialogue("Dont waste water")
		
	if Stats.valley_closed:
		_dialogue("Dont close me")
		
	if Stats.ram_maxed:
		_dialogue("Out of RAM")
	
func _add_dialogue(id: String, text: String, icon: Texture2D = null) -> void:
	dialogue_list.append(_Dialogue.new(id, text, icon))
	
func _dialogue(id: String) -> void:
	for dial in dialogue_list:
		if dial.id == id:
			dial.dialogue()
			return
			
func get_time() -> float:
	return GlobalFunctions.get_time()
