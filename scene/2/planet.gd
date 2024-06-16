extends MarginContainer


#region var
@onready var gods = $HBox/Gods

var universe = null
var rank = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	universe = input_.universe
	
	
	init_basic_setting()


func init_basic_setting() -> void:
	rank = 1
	var input = {}
	input.planet = self


func add_god(god_: MarginContainer) -> void:
	god_.pantheon.gods.remove_child(god_)
	gods.add_child(god_)
	god_.planet = self
#endregion


func start_race() -> void:
	pass
	#for god in gods.get_children():
		#var god = gods.get_child(0)
	#	god.domain.roll_areas()
	
	#for area in continent.areas.get_children():
	#	area.recolor_based_on_density()
