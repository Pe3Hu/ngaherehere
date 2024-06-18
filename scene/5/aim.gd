extends MarginContainer


#region var
@onready var targets = $Targets
@onready var first = $Targets/First
@onready var second = $Targets/Second
@onready var third = $Targets/Third

var clash = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	clash = input_.clash
	
	init_basic_setting()


func init_basic_setting() -> void:
	pass


func init_targets() -> void:
	var options = []
	var framework = clash.roles.defense.framework
	options.append_array(framework.modules.get_children())
	
	options.erase(framework.nexus)
	
	for type in Global.arr.target:
		var input = {}
		input.aim = self
		input.module = options.pick_random()
		options.erase(input.module)
		var target = get(type)
		target.set_attributes(input)
#end region


func penetration_test() -> void:
	for target in targets.get_children():
		var offense = target.offense.get_value()
		var defense = target.defense.get_value()
		
		if offense > defense:
			target.module.get_damage()
			target.gear.change_value(-1)
