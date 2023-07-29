extends Node

const NOT_SET: 			int = 0
const POT: 				int = 1
const WATER: 			int = 2
const WATERING_CAN: 	int = 3
const GARDEN:			int = 4
const VALLEY:			int = 5
const SEED:				int = 6
const SHIP:				int = 7
#const STORE:			int = 
#const STATS:			int = 
#const TREE:			int = 

const NUMBER_OF_NAMES: 	int = 8

var single_window_list: = []

func _ready():
	single_window_list.resize(NUMBER_OF_NAMES)
	single_window_list.fill(false)
	single_window_list[VALLEY] = true
	single_window_list[WATER] = true
	single_window_list[GARDEN] = true
	single_window_list[SHIP] = true
