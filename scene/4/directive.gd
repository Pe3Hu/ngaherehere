extends MarginContainer


#region var
@onready var axisO = $VBox/Orientations/Axis
@onready var centerO = $VBox/Orientations/Center
@onready var edgeO = $VBox/Orientations/Edge
@onready var axisD = $VBox/Distributions/Axis
@onready var centerD = $VBox/Distributions/Center
@onready var edgeD = $VBox/Distributions/Edge

var dispenser = null
var role = null
var doublets = []
var grids = []
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	dispenser = input_.dispenser
	role = input_.role
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	init_tokens(input_)
	init_doublets()


func init_tokens(input_: Dictionary) -> void:
	for type in Global.arr.target:
		var tokens = {}
		tokens.d = get(type + "D")
		var input = {}
		input.proprietor = self
		input.type = "distribution"
		input.subtype = type
		Global.rng.randomize()
		input.value = Global.rng.randi_range(Global.num.distribution.min, Global.num.distribution.max)
		
		tokens.d.set_attributes(input)
		tokens.d.custom_minimum_size = Global.vec.size.directive# * 2
		
		tokens.o = get(type + "O")
		input.type = type
		input.subtype = input_[type]
		input.erase("value")
		
		tokens.o.set_attributes(input)
		tokens.o.custom_minimum_size = tokens.d.custom_minimum_size
		tokens.o.size = tokens.d.size


func init_doublets() -> void:
	grids = []
	var orientations = []
	
	for type in Global.arr.target:
		var token = get_token(type, "orientation")
		orientations.append(token.subtype)
	
		if type == "axis":
			var modules = dispenser.god.framework.axes[token.subtype]
			
			for module in modules:
				grids.append([module.grid])
		else:
			var index = Global.arr.axis.find(orientations.front())
			var shift = 0
			
			match token.subtype:
				"clockwise":
					shift = 1
				"counter clockwise":
					shift = -1
			
			var n = Global.dict.neighbor.linear.size()
			index = (index + shift + n) % n
			var directon = Global.dict.neighbor.linear[index]
			var k = Global.arr.target.find(type)
			
			for _i in grids.size():
				var grid = Vector2i(grids[_i].front())
				grid += directon * k
				grids[_i].append(grid)
	
	for _grids in grids:
		var pairs = Global.get_all_constituents_based_on_size(_grids, 2)
		
		for pair in pairs:
			pair.sort_custom(func(a, b): return a.x + a.y < b.x + b.y)
			
			var flag = false
			var doublet = null
			
			if dispenser.god.framework.doublets.has(pair.front()):
				if dispenser.god.framework.doublets[pair.front()].has(pair.back()):
					flag = true
					doublet = dispenser.god.framework.doublets[pair.front()][pair.back()]
			
			if !flag:
				var input = {}
				input.framework = dispenser.god.framework
				input.grids = pair
				doublet = Classes.Doublet.new(input)
			
			doublet.directives[role].append(self)
			doublets.append(doublet)


func get_token(type_: String, subtype_: String) -> MarginContainer:
	var letter = subtype_[0].capitalize()
	var token = get(type_ + letter)
	return token
#endregion


func set_as_active() -> void:
	var directives = dispenser.get(role+"s")
	directives.remove_child(self)
	dispenser.actives.add_child(self)


func get_grids_based_on_axis(axis_: Vector2i) -> Array:
	for _grids in grids:
		if _grids.has(axis_):
			return _grids
	
	return []
