extends Node

const _texture_o: Texture2D = preload("res://Assets/Sprites/Apps/Valley/app__valley__o.png")
const _texture_hi: Texture2D = preload("res://Assets/Sprites/Apps/Valley/app__valley__hi.png")
const _texture_oo: Texture2D = preload("res://Assets/Sprites/Apps/Valley/app__valley__oo.png")
const _texture_smug: Texture2D = preload("res://Assets/Sprites/Apps/Valley/app__valley__smug.png")
const _texture_angry: Texture2D = preload("res://Assets/Sprites/Apps/Valley/app__valley__angry.png")
const _texture_smile: Texture2D = preload("res://Assets/Sprites/Apps/Valley/app__valley__smile.png")
const _texture_won: Texture2D = preload("res://Assets/Sprites/Apps/Valley/app__valley__won.png")
const _texture_lose: Texture2D = preload("res://Assets/Sprites/Apps/Valley/app__valley__lose.png")

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
	_add_dialogue("Hi", "Hi! Im Valley. Im living rent free in your desktop", _texture_hi)
	_add_dialogue("Drag", "That is a pot, you can drag seed into it", _texture_smile)
	_add_dialogue("Dont waste water", "Hey, dont waste water", _texture_o)
	_add_dialogue("Dont close me", "Heeeeey, dont close me, I run in background, you wont get any RAM back", _texture_angry)
	_add_dialogue("Out of RAM", "You are out of RAM. Maybe close some windows?", _texture_o)
	_add_dialogue("Crow", "Oh, a crow", _texture_o)
	
	_add_dialogue("Tick", "You wanna play tic tac toe? Im really good at tic tac toe", _texture_smile)
	_add_dialogue("Tick won", "Yey, I won!", _texture_won)
	_add_dialogue("Tick lose", "No way! You are just lucky! Again, again!", _texture_lose)
	_add_dialogue("Tick draw", "Ah, we draw", _texture_o)
			
func _process(delta):
	if not GlobalVars.valley_opened and not Stats.pot_opened and not Stats.tick_opened and get_time() > 2:
		dialogue("Click me")
		
	if GlobalVars.valley_opened:
		dialogue("Hi")
		
	if Stats.pot_opened >= 1:
		dialogue("Drag")
		
	if Stats.water_dispensed:
		dialogue("Dont waste water")
		
	if Stats.valley_closed:
		dialogue("Dont close me")
		
	if Stats.ram_maxed:
		dialogue("Out of RAM")
		
	if Stats.crow_appeared >= 1:
		dialogue("Crow")
		
	if Stats.valley_won:
		dialogue("Tick won")
		
	if Stats.valley_lose:
		dialogue("Tick lose")
		
	if Stats.valley_draw:
		dialogue("Tick draw")
		
	if Stats.tick_opened:
		dialogue("Tick")
	
func _add_dialogue(id: String, text: String, icon: Texture2D = null) -> void:
	dialogue_list.append(_Dialogue.new(id, text, icon))
	
func dialogue(id: String) -> void:
	for dial in dialogue_list:
		if dial.id == id:
			dial.dialogue()
			return
			
func get_time() -> float:
	return GlobalFunctions.get_time()
