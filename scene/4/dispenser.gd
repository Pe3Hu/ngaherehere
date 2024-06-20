extends MarginContainer


#region var
@onready var offenses = $Directives/Offenses
@onready var defenses = $Directives/Defenses
@onready var actives = $Directives/Actives
@onready var reboots = $Directives/Reboots

var god = null
var core = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	god = input_.god
	
	init_basic_setting()


func init_basic_setting() -> void:
	core = god.core
	#core.dispenser = self
	
	init_directives()


func init_directives() -> void:
	for role in Global.arr.role:
		for axis in Global.arr.axis:
			for center in Global.arr.center:
				for edge in Global.arr.edge:
					add_directive(role, axis, center, edge)


func add_directive(role_: String, axis_: String, center_: String, edge_: String) -> void:
	var input = {}
	input.dispenser = self
	input.role = role_
	input.axis = axis_
	input.center = center_
	input.edge = edge_
	
	var directive = Global.scene.directive.instantiate()
	var directives = get(role_+"s")
	directives.add_child(directive)
	directive.set_attributes(input)

