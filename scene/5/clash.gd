extends MarginContainer


#region var
@onready var offense = $HBox/Roles/Offense
@onready var defense = $HBox/Roles/Defense
@onready var aim = $HBox/Aim

var planet = null
var gods = {}
var roles = {}
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	planet = input_.planet
	
	init_basic_setting()


func init_basic_setting() -> void:
	var input = {}
	input.clash = self
	aim.set_attributes(input)


func set_role(god_: MarginContainer, role_: String) -> void:
	gods[god_] = role_
	roles[role_] = god_
	var token = get(role_)
	token.replicate(god_.index)
	#var input = {}
	#input.proprietor = self
	#input.type = "clash"
	#input.subtype = role_
	#token.set_attributes(input)
	#token.custom_minimum_size = Global.vec.size.clash
	
	if gods.keys().size() == 2:
		aim.init_targets()
		roll_impacts()
		spread_impacts()
		aim.penetration_test()


func roll_impacts() -> void:
	for god in gods:
		var role = gods[god]
		god.library.activate_software(role)


func spread_impacts() -> void:
	for god in gods:
		god.tactician.set_clash(self)
#end region

