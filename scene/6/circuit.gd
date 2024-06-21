extends MarginContainer


#region var
@onready var chips = $HBox/Chips
@onready var isolation = $HBox/VBox/Isolation
@onready var consumption = $HBox/VBox/Consumption
@onready var lethality = $HBox/Specializations/Lethality
@onready var durability = $HBox/Specializations/Sensory
@onready var sensory = $HBox/Specializations/Durability
@onready var mobility = $HBox/Specializations/Mobility

var proprietor = null
var type = null
var indexs = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	proprietor = input_.proprietor
	type = input_.type
	indexs = input_.indexs
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_tokens()
	init_chips()


func init_tokens() -> void:
	for subtype in Global.arr.specialization:
		var token = get(subtype)
		var input = {}
		input.proprietor = self
		input.type = "specialization"
		input.subtype = subtype
		input.value = 0
		token.set_attributes(input)
		token.custom_minimum_size = Global.vec.size.circuit
		token.set_bg_color(Global.color.specialization[subtype])
	
	for subtype in Global.arr.circuit:
		var token = get(subtype)
		var input = {}
		input.proprietor = self
		input.type = "circuit"
		input.subtype = subtype
		
		match subtype:
			"isolation":
				input.type = "gear"
				input.subtype = type
				input.value = 3
			"consumption":
				input.value = 1
		
		token.set_attributes(input)
		token.custom_minimum_size = Global.vec.size.circuit
		
		if subtype == "insolation":
			
			token.set_bg_color(Global.color.module[type])


func init_chips() -> void:
	for _i in indexs:
		add_chip()


func add_chip() -> void:
	var input = {}
	input.proprietor = self
	
	var chip = Global.scene.chip.instantiate()
	chips.add_child(chip)
	chip.set_attributes(input)
#endregion
