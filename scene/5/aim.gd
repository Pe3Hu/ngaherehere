extends MarginContainer


#region var
@onready var targets = $Targets
@onready var axis = $Targets/Axis
@onready var center = $Targets/Center
@onready var edge = $Targets/Edge

var clash = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	clash = input_.clash
	
	init_basic_setting()


func init_basic_setting() -> void:
	pass


func init_targets() -> void:
	var directive = clash.roles["offense"].dispenser.actives.get_child(0)
	var _axis = clash.roles["offense"].tactician.axis
	
	for _grids in directive.grids:
		if _grids.has(_axis):
			for grid in _grids:
				var index = _grids.find(grid)
				var input = {}
				input.aim = self
				input.type = Global.arr.target[index]
				input.module = clash.roles["defense"].framework.grids[grid]
				var target = get(input.type)
				target.set_attributes(input)
#end region


func penetration_test() -> void:
	for target in targets.get_children():
		var offense = target.offense.get_value()
		var defense = target.defense.get_value()
		
		if offense > defense:
			target.module.get_damage()
			target.gear.change_value(-1)
