class_name App_TicTacToe
extends Node2D

const VALLEY_DELAY: float = 2

#@onready var _window_list: Node2D = get_node("/root/Main/WindowList")
const _texture__board: Texture2D = preload("res://Assets/Sprites/Apps/TicTacToe/app__tic_tac_toe__board.png")
const _texture__x: Texture2D = preload("res://Assets/Sprites/Apps/TicTacToe/app__tic_tac_toe__x.png")
const _texture__o: Texture2D = preload("res://Assets/Sprites/Apps/TicTacToe/app__tic_tac_toe__o.png")
var _window: Game_Window

enum _Tick {
	EMPTY,
	X,
	O,
	DRAW,
}
var _ticked = []
var _buttons = []

var _valleys_turn: bool = true
var _valleys_turn_started_at: float = 0

var _winner_is: _Tick = _Tick.EMPTY

func _init(window: Game_Window):
	_window = window
	
	_window._w = 90
	_window._h = 90 + 10
	_window._min_w = 90
	_window._max_w = 90
	_window._min_h = 90 + 10
	_window._max_h = 90 + 10
	
	for i in 3:
		_buttons.append([])
		_ticked.append([])
		
	for i in 3:
		for j in 3:
			var _button = Game_Button.new((i * 25 + 8)*2, (j * 25 + 19)*2, 20, 20, 2, Color(0, 0, 0, 0))
			_buttons[i].append(_button)
			_button.show_button()
			add_child(_button)
			
			_ticked[i].append(_Tick.EMPTY)
	
	_valleys_turn_started_at = Time.get_ticks_msec()
	
func draw_app_content() -> void:
	_window.draw_texture(_texture__board, Vector2(5, 15))
	
	for i in 3:
		for j in 3:
			if _ticked[i][j] == _Tick.X:
				_window.draw_texture(_texture__x, Vector2(i * 25 + 8, j * 25 + 19))
			elif _ticked[i][j] == _Tick.O:
				_window.draw_texture(_texture__o, Vector2(i * 25 + 8, j * 25 + 19))
			
func update(_delta: float) -> void:
	for i in 3:
		for j in 3:
			_buttons[i][j].update(_delta)
			
	if _winner_is != _Tick.EMPTY:
		for i in 3:
			for j in 3:
				if _buttons[i][j].just_pressed():
					_reset_game()
		return
		
	if not _valleys_turn:
		_player_turn_func()
		return
		
	if _valleys_turn and Time.get_ticks_msec() - _valleys_turn_started_at > VALLEY_DELAY * 1000:
		_valleys_turn_func()
		_valleys_turn = false
		if _winner() == _Tick.X:
			_winner_is = _Tick.X
			Stats.valley_won = true
		elif _winner() == _Tick.DRAW:
			_winner_is = _Tick.DRAW
			Stats.valley_draw = true
					
func _player_turn_func() -> void:
	for i in 3:
		for j in 3:
			if _buttons[i][j].just_pressed() and _ticked[i][j] == _Tick.EMPTY:
				_ticked [i][j] = _Tick.O
				_valleys_turn = true
				_valleys_turn_started_at = Time.get_ticks_msec()
				if _winner() == _Tick.O:
					_winner_is = _Tick.O
					Stats.valley_lose = true
				elif _winner() == _Tick.DRAW:
					_winner_is = _Tick.DRAW
					Stats.valley_draw = true

func _valleys_turn_func() -> void:
	if _valley_tick(_Tick.X):
		return
		
	if _valley_tick(_Tick.O):
		return
	
	var possible_tick_list: = []
	for i in 3:
		for j in 3:
			if _ticked[i][j] == _Tick.EMPTY:
				possible_tick_list.append(Vector2i(i, j))
				
	var choosen_tick: Vector2i = possible_tick_list[randi_range(0, possible_tick_list.size() - 1)]
	_ticked[choosen_tick.x][choosen_tick.y] = _Tick.X
	
func _valley_tick(tick: _Tick) -> bool:
	for i in 3:
		var o_ticked_num: int = 0
		for j in 3:
			if _ticked[i][j] == tick:
				o_ticked_num += 1
		if o_ticked_num == 2:
			for j in 3:
				if _ticked[i][j] == _Tick.EMPTY:
					_ticked[i][j] = _Tick.X
					return true
		
	for j in 3:
		var o_ticked_num: int = 0
		for i in 3:
			if _ticked[i][j] == tick:
				o_ticked_num += 1
		if o_ticked_num == 2:
			for i in 3:
				if _ticked[i][j] == _Tick.EMPTY:
					_ticked[i][j] = _Tick.X
					return true
					
	var o_ticked_num: int = 0
	for i in 3:
		if _ticked[i][i] == tick:
				o_ticked_num += 1
	if o_ticked_num == 2:
		for i in 3:
			if _ticked[i][i] == _Tick.EMPTY:
				_ticked[i][i] = _Tick.X
				return true
				
	o_ticked_num = 0
	for i in 3:
		if _ticked[i][3 - i - 1] == tick:
				o_ticked_num += 1
	if o_ticked_num == 2:
		for i in 3:
			if _ticked[i][3 - i - 1] == _Tick.EMPTY:
				_ticked[i][3 - i - 1] = _Tick.X
				return true
				
	return false
	
func _winner() -> _Tick:
	if _winner_tick(_ticked, _Tick.X):
		return _Tick.X
	
	if _winner_tick(_ticked, _Tick.O):
		return _Tick.O
		
	var all_tiles_ticked: bool = true
	for i in 3:
		for j in 3:
			if _ticked[i][j] == _Tick.EMPTY:
				all_tiles_ticked = false
	if all_tiles_ticked:
		return _Tick.DRAW
		
	return _Tick.EMPTY
	
func _winner_tick(board: Array, tick: _Tick) -> bool:
	for i in 3:
		var win_1: bool = true
		for j in 3: 
			if board[i][j] != tick:
				win_1 = false
		if win_1:
			return true
			
	for j in 3:
		var win_1: bool = true
		for i in 3: 
			if board[i][j] != tick:
				win_1 = false
		if win_1:
			return true
			
	var win_1: bool = true
	for i in 3:
		if board[i][i] != tick:
			win_1 = false
	if win_1:
		return true
		
	win_1 = true
	for i in 3:
		if board[i][3 - i - 1] != tick:
			win_1 = false
	if win_1:
		return true
		
	return false

func _reset_game():
	for i in 3:
		for j in 3:
			_ticked[i][j] = _Tick.EMPTY
			
	_valleys_turn = true
	_valleys_turn_started_at = Time.get_ticks_msec()
	_winner_is = _Tick.EMPTY
