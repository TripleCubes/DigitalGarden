extends Node

const NOT_SET: 			int = 0
const POT: 				int = 1
const WATER: 			int = 2
const WATERING_CAN: 	int = 3
const GARDEN:			int = 4
const VALLEY:			int = 5
const SEED:				int = 6
const STORE:			int = 7
const STATS:			int = 8
const TREE:				int = 9
const SHIP:				int = 10

const NUMBER_OF_NAMES: 	int = 7

var single_window_list: = []

func _ready():
	single_window_list.resize(NUMBER_OF_NAMES)
	single_window_list.fill(false)
	single_window_list[VALLEY] = true
	single_window_list[WATER] = true
	single_window_list[GARDEN] = true
