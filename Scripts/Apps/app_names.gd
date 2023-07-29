extends Node

const NOT_SET: 			int = 0
const POT: 				int = 1
const WATER: 			int = 2
const WATERING_CAN: 	int = 3
const GARDEN:			int = 4
const VALLEY:			int = 5
const SEED:				int = 6
const SHIP:				int = 7
const CROW:				int = 8
const STATS:			int = 9
#const STORE:			int = 
#const TREE:			int = 

const NUMBER_OF_NAMES: 	int = 10

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
