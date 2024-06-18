extends Node


var rng = RandomNumberGenerator.new()
var arr = {}
var num = {}
var vec = {}
var color = {}
var dict = {}
var flag = {}
var node = {}
var scene = {}


func _ready() -> void:
	init_arr()
	init_num()
	init_vec()
	init_color()
	init_dict()
	init_scene()


func init_arr() -> void:
	arr.gear = ["head", "limb", "torso"]
	arr.specialization = ["lethality", "durability", "sensory", "mobility"]
	arr.auxiliary = ["sensory", "mobility"]
	arr.impact = ["minimum", "maximum"]
	arr.summand = ["amplifier", "spread"]
	arr.role = ["offense", "defense"]


func init_num() -> void:
	num.index = {}
	num.index.god = 0
	
	num.framework = {}
	num.framework.n = 5
	
	num.module = {}
	num.module.a = 36
	num.module.r = num.module.a / sqrt(2)
	
	num.amplifier = {}
	num.amplifier.n = 5
	num.amplifier.share = 0.5


func init_dict() -> void:
	init_neighbor()
	init_font()
	
	init_totem()
	init_specialization()
	init_software()


func init_neighbor() -> void:
	dict.neighbor = {}
	dict.neighbor.linear = [
		Vector2i( 0,-1),
		Vector2i( 1, 0),
		Vector2i( 0, 1),
		Vector2i(-1, 0)
	]
	dict.neighbor.diagonal = [
		Vector2i( 1,-1),
		Vector2i( 1, 1),
		Vector2i(-1, 1),
		Vector2i(-1,-1)
	]
	dict.neighbor.zero = [
		Vector2i( 0, 0),
		Vector2i( 1, 0),
		Vector2i( 1, 1),
		Vector2i( 0, 1)
	]


func init_font() -> void:
	dict.font = {}
	dict.font.size = {}
	dict.font.size["basic"] = 18
	dict.font.size["season"] = 18
	dict.font.size["phase"] = 18
	dict.font.size["moon"] = 18


func init_totem() -> void:
	dict.totem = {}
	dict.totem.title = {}
	var exceptions = ["title"]
	
	var path = "res://asset/json/ngaherehere_totem.json"
	var array = load_data(path)
	
	for totem in array:
		var data = {}
		
		for key in totem:
			if !exceptions.has(key):
				var words = key.split(" ")
				
				if !data.has(words[0]):
					data[words[0]] = {}
				
				data[words[0]][words[1]] = totem[key]
	
		dict.totem.title[totem.title] = data


func init_specialization() -> void:
	dict.specialization = {}
	dict.specialization.title = {}
	var exceptions = ["title"]
	
	var path = "res://asset/json/ngaherehere_specialization.json"
	var array = load_data(path)
	
	for specialization in array:
		var data = {}
		
		for key in specialization:
			if !exceptions.has(key):
				data[key] = specialization[key]
	
		dict.specialization.title[specialization.title] = data


func init_software() -> void:
	dict.software = {}
	dict.software.rank = {}
	var exceptions = ["rank"]
	
	var path = "res://asset/json/ngaherehere_software.json"
	var array = load_data(path)
	
	for software in array:
		software.rank = int(software.rank)
		var data = {}
		
		for key in software:
			if !exceptions.has(key):
				data[key] = software[key]
	
		dict.software.rank[software.rank] = data
	
	dict.role = {}
	dict.role["offense"] = "lethality"
	dict.role["defense"] = "durability"


func init_scene() -> void:
	scene.pantheon = load("res://scene/1/pantheon.tscn")
	scene.god = load("res://scene/1/god.tscn")
	
	scene.planet = load("res://scene/2/planet.tscn")
	
	scene.module = load("res://scene/3/module.tscn")
	
	scene.software = load("res://scene/4/software.tscn")


func init_vec():
	vec.size = {}
	vec.size.sixteen = Vector2(16, 16)
	
	vec.size.token = Vector2(vec.size.sixteen * 2)
	vec.size.module = Vector2.ONE * num.module.a
	vec.size.specialization = vec.size.module# * 1.25
	vec.size.software = Vector2(vec.size.specialization)
	
	
	init_window_size()


func init_window_size():
	vec.size.window = {}
	vec.size.window.width = ProjectSettings.get_setting("display/window/size/viewport_width")
	vec.size.window.height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window.center = Vector2(vec.size.window.width/2, vec.size.window.height/2)


func init_color():
	var h = 360.0
	
	color.module = {}
	color.module.head = Color.from_hsv(330 / h, 0.6, 0.7)
	color.module.limb = Color.from_hsv(300 / h, 0.6, 0.7)
	color.module.torso = Color.from_hsv(270 / h, 0.6, 0.7)
	
	color.specialization = {}
	color.specialization.lethality = Color.from_hsv(0 / h, 0.6, 0.7)
	color.specialization.sensory = Color.from_hsv(60 / h, 0.6, 0.7)
	color.specialization.mobility = Color.from_hsv(120 / h, 0.6, 0.7)
	color.specialization.durability = Color.from_hsv(210 / h, 0.6, 0.7)
	
	color.impact = {}
	color.impact.offense = {}
	color.impact.offense.maximum = Color.from_hsv(0 / h, 0.7, 1.0)
	color.impact.offense.minimum = Color.from_hsv(0 / h, 0.7, 0.6)
	color.impact.defense = {}
	color.impact.defense.maximum = Color.from_hsv(210 / h, 0.7, 1.0)
	color.impact.defense.minimum = Color.from_hsv(210 / h, 0.7, 0.6)
	
	color.summand = {}
	color.summand.spread = Color.from_hsv(180 / h, 0.55, 0.6)
	color.summand.amplifier = Color.from_hsv(330 / h, 0.55, 0.6)


func save(path_: String, data_: String):
	var path = path_ + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data_)


func load_data(path_: String):
	var file = FileAccess.open(path_, FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var _parse_err = json_object.parse(text)
	return json_object.get_data()


func get_random_key(dict_: Dictionary):
	if dict_.keys().size() == 0:
		print("!bug! empty array in get_random_key func")
		return null
	
	var total = 0
	
	for key in dict_.keys():
		total += dict_[key]
	
	rng.randomize()
	var index_r = rng.randf_range(0, 1)
	var index = 0
	
	for key in dict_.keys():
		var weight = float(dict_[key])
		index += weight/total
		
		if index > index_r:
			return key
	
	print("!bug! index_r error in get_random_key func")
	return null
