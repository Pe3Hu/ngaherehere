extends MarginContainer


#region var
@onready var bg = $BG
@onready var specialization = $Specialization

var proprietor = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	proprietor = input_.proprietor
	
	init_basic_setting()


func init_basic_setting() -> void:
	roll_specialization()


func roll_specialization() -> void:
	var input = {}
	input.proprietor = self
	input.type = "specialization"
	input.subtype = Global.arr.specialization.pick_random()
	Global.rng.randomize()
	input.value = Global.rng.randi_range(Global.num.chip.min, Global.num.chip.max)
	specialization.set_attributes(input)
	specialization.custom_minimum_size = Global.vec.size.chip
	specialization.set_bg_color(Global.color.specialization[input.subtype])
#endregion
