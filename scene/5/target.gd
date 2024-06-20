extends MarginContainer


#region var
@onready var offense = $VBox/Offense
@onready var defense = $VBox/Defense
@onready var gear = $VBox/Gear

var aim = null
var type = null
var module = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	aim = input_.aim
	type = input_.type
	module = input_.module
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_tokens()


func init_tokens() -> void:
	var input = {}
	input.proprietor = self
	input.type = "target"
	input.subtype = "offense"
	offense.set_attributes(input)
	offense.custom_minimum_size = Global.vec.size.target
	
	input.subtype = "defense"
	defense.set_attributes(input)
	defense.custom_minimum_size = Global.vec.size.target
	
	gear.replicate(module.gear)
#end region

