extends MarginContainer


#region var
@onready var lethality = $Specializations/Lethality
@onready var durability = $Specializations/Sensory
@onready var sensory = $Specializations/Durability
@onready var mobility = $Specializations/Mobility

var god = null
var framework = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	god = input_.god
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_tokens()


func init_tokens() -> void:
	for specialization in Global.arr.specialization:
		var token = get(specialization)
		var input = {}
		input.proprietor = self
		input.type = "specialization"
		input.subtype = specialization
		input.value = 0
		token.set_attributes(input)
		token.custom_minimum_size = Global.vec.size.specialization
		token.set_bg_color(Global.color.specialization[specialization])


func change_specialization_value(specialization_: String, value_: int) -> void:
	var token = get(specialization_)
	token.change_value(value_)
#endregion
