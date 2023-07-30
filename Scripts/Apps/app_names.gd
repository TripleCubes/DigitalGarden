extends Node

const NOT_SET: 			int = 0
const VALLEY:			int = 1
const POT: 				int = 2
const SEED:				int = 3
const WATER: 			int = 4
const WATERING_CAN: 	int = 5
const TREE:				int = 6
const STATS:			int = 7
const TASKS:			int = 8
const GARDEN:			int = 9
const SHIP:				int = 10
const CROW:				int = 11

const NUMBER_OF_NAMES: 	int = 12

var single_window_list: = []
var ram_list: = []

func _ready():
	single_window_list.resize(NUMBER_OF_NAMES)
	single_window_list.fill(false)
	single_window_list[VALLEY] = true
	single_window_list[WATER] = true
	single_window_list[GARDEN] = true
	single_window_list[SHIP] = true
	single_window_list[STATS] = true
	single_window_list[TASKS] = true
	single_window_list[TREE] = true
	
	ram_list.resize(NUMBER_OF_NAMES)
	ram_list[NOT_SET] = 0
	ram_list[POT] = 1
	ram_list[WATER] = 1
	ram_list[WATERING_CAN] = 1
	ram_list[GARDEN] = 3
	ram_list[VALLEY] = 0
	ram_list[SEED] = 1
	ram_list[SHIP] = 3
	ram_list[CROW] = 1
	ram_list[STATS] = 1
	ram_list[TASKS] = 1
	ram_list[TREE] = 2
