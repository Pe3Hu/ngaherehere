extends MarginContainer


#region var
@onready var softwares = $Softwares

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
	add_software(0)


func add_software(rank_: int) -> void:
	var input = {}
	input.library = self
	input.rank = rank_
	
	var software = Global.scene.software.instantiate()
	softwares.add_child(software)
	software.set_attributes(input)
