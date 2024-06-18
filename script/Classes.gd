extends Node


class Tactician:
	var god = null
	var clash = null
	var role = null


	func _init(input_: Dictionary) -> void:
		god = input_.god
	
		init_basic_setting()


	func init_basic_setting() -> void:
		pass
	
	
	func set_clash(clash_: MarginContainer) -> void:
		clash = clash_
		role = clash.gods[god]
		spread_impacts()
	
	
	func spread_impacts() -> void:
		var limit = god.library.impact.get_value()
		var importances = {}
		var minimum = floor(limit * Global.num.target.min)
		
		for type in Global.arr.target:
			var target = clash.aim.get(type)
			importances[target] = 1
			var impact = target.get(role)
			impact.change_value(minimum)
			limit -= minimum
		
		while limit > 0:
			var target = Global.get_random_key(importances)
			var impact = target.get(role)
			var _max = min(impact.get_value() / 2, limit)
			Global.rng.randomize()
			var value = Global.rng.randi_range(1, _max)
			limit -= value
			impact.change_value(value)
