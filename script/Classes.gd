extends Node


class State:
	var mainland = null


	func _init(input_: Dictionary) -> void:
		mainland = input_.mainland
	
		init_basic_setting(input_)


	func init_basic_setting(_input_: Dictionary) -> void:
		pass
