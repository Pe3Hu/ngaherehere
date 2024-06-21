extends MarginContainer


#region var
@onready var circuits = $HBox/Circuits
@onready var modules = $HBox/Modules
@onready var energy = $HBox/Energy

var god = null
var core = null
var nexus = null
var totem = null
var grids = {}
var axes = {}
var doublets = {}
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	god = input_.god
	
	init_basic_setting()


func init_basic_setting() -> void:
	totem = Global.dict.framework.title.keys()[0]#.pick_random()
	core = god.core
	core.framework = self
	
	init_modules()
	init_indicator()


func init_modules() -> void:
	custom_minimum_size = Global.num.framework.n * Global.vec.size.module
	modules.columns = Global.num.framework.n
	
	for _i in Global.num.framework.n:
		for _j in Global.num.framework.n:
			var grid = Vector2i(_j, _i)
			add_module(grid)
	
	update_module_neighbors()
	init_circuits()
	init_axes()


func add_module(grid_: Vector2i) -> void:
	var input = {}
	input.proprietor = self
	input.grid = grid_
	input.orientation = "center"
	var corners = [0, Global.num.framework.n - 1]
	var axis = int(Global.num.framework.n / 2) 
	
	if corners.has(grid_.x) and corners.has(grid_.y):
		input.orientation = "corner"
	else:
		if grid_.x == axis or grid_.y == axis:
			input.orientation = "axis"
			
			if grid_.x == grid_.y:
				input.orientation = "nexus"
	
	var module = Global.scene.module.instantiate()
	modules.add_child(module)
	module.set_attributes(input)
	
	if input.orientation == "nexus":
		nexus = module


func update_module_neighbors() -> void:
	for module in modules.get_children():
		for direction in Global.dict.neighbor.linear:
			var grid = direction + module.grid
			
			if grids.has(grid):
				var neighbor = grids[grid]
				
				if !module.neighbors.has(neighbor):
					module.neighbors[neighbor] = direction
					neighbor.neighbors[module] = -direction
					module.directions[direction] = neighbor
					neighbor.directions[-direction] = module


func init_circuits() -> void:
	var description = Global.dict.framework.title[totem]
	
	for order in description.circuits:
		var type = description.gears[order]
		var indexs = description.circuits[order]
		
		add_circuit(type, indexs)
		
		for index in indexs:
			var module = modules.get_child(index)
			module.set_type(type)


func add_circuit(type_: String, indexs_: Array) -> void:
	var input = {}
	input.proprietor = self
	input.type = type_
	input.indexs = indexs_
	
	var circuit = Global.scene.circuit.instantiate()
	circuits.add_child(circuit)
	circuit.set_attributes(input)


func init_axes() -> void:
	for type in Global.arr.axis:
		axes[type] = []
		var index = Global.arr.axis.find(type)
		
		var directon = Global.dict.neighbor.linear[index]
		var module = nexus
		
		for _i in Global.num.framework.k:
			module = module.directions[directon]
			axes[type].append(module)


func init_indicator() -> void:
	var input = {}
	input.framework = self
	input.type = "energy"
	input.max = 100
	energy.set_attributes(input)
#endregion

