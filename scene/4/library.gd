extends MarginContainer


#region var
@onready var offenses = $Softwares/Offenses
@onready var defenses = $Softwares/Defenses
@onready var actives = $Softwares/HBox/Actives
@onready var impact = $Softwares/HBox/Impact
@onready var reboots = $Softwares/Reboots

var god = null
var core = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	god = input_.god
	
	init_basic_setting()


func init_basic_setting() -> void:
	core = god.core
	#core.library = self
	
	init_tokens()
	init_softwares()


func init_tokens() -> void:
	var input = {}
	input.proprietor = self
	input.type = "library"
	input.subtype = "impact"
	input.value = 0
	impact.set_attributes(input)
	impact.custom_minimum_size = Global.vec.size.target


func init_softwares() -> void:
	var n = 10
	var rank = 0
	
	for _i in n:
		for role in Global.arr.role:
			add_software(rank, role)


func add_software(rank_: int, role_: String) -> void:
	var input = {}
	input.library = self
	input.rank = rank_
	input.role = role_
	
	var software = Global.scene.software.instantiate()
	var softwares = get(role_+"s")
	softwares.add_child(software)
	software.set_attributes(input)


func activate_software(role_: String) -> void:
	var software = pull_random_software(role_)
	var minimum = software.minimum.get_value()
	var maximum = software.maximum.get_value()
	Global.rng.randomize()
	var value = Global.rng.randi_range(minimum, maximum)
	impact.change_value(value)


func pull_random_software(role_: String) -> MarginContainer:
	var softwares = get(role_+"s")
	var software = softwares.get_children().pick_random()
	softwares.remove_child(software)
	actives.add_child(software)
	return software
