extends MarginContainer


#region var
@onready var maximum = $Softwares/Impacts/Maximum
@onready var minimum = $Softwares/Impacts/Minimum
@onready var lethality = $Softwares/Multipliers/Lethality
@onready var durability = $Softwares/Multipliers/Durability
@onready var sensory = $Softwares/Multipliers/Sensory
@onready var mobility = $Softwares/Multipliers/Mobility
@onready var spread = $Softwares/Summands/Spread
@onready var amplifier = $Softwares/Summands/Amplifier

var library = null
var rank = null
var role = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	library = input_.library
	rank = input_.rank
	
	init_basic_setting()


func init_basic_setting() -> void:
	role = "offense"
	init_tokens()
	roll_values()


func init_tokens() -> void:
	var keys = ["impact", "specialization", "summand"]
	
	for key in keys:
		for type in Global.arr[key]:
			var token = get(type)
			var input = {}
			input.proprietor = self
			input.type = key
			input.subtype = type
			input.value = 0
			
			token.set_attributes(input)
			token.custom_minimum_size = Global.vec.size.software
			
			if key != "impact":
				token.set_bg_color(Global.color[key][type])
			else:
				token.set_bg_color(Global.color[key][role][type])


func roll_values() -> void:
	var description = Global.dict.software.rank[rank]
	var specializations = {}
	specializations.base = Global.dict.role[role]
	var options = []
	options.append_array(Global.arr.auxiliary)
	options.shuffle()
	specializations.primary = options.pop_front()
	specializations.secondary = options.pop_front()
	
	for key in specializations:
		var specialization = specializations[key]
		var token = get(specialization)
		var value = description[key]
		token.set_value(value)
	
	spread.set_value(description["spread"])
	roll_amplifier()
	update_impacts()


func roll_amplifier() -> void:
	var description = Global.dict.software.rank[rank]
	var multipliers = description.base + description.primary + description.secondary
	var bets = {}
	bets.amplifier = description.amplifier / Global.num.amplifier.n
	bets.multiplier = multipliers / Global.num.amplifier.n * Global.num.amplifier.share
	
	for _i in Global.num.amplifier.n:
		var rolls = {}
		
		for key in bets:
			var _min = 0# - ceil(bets[key] / 2)
			var _max = bets[key]
			Global.rng.randomize()
			rolls[key] = Global.rng.randi_range(_min, _max)
		
		amplifier.change_value(rolls["amplifier"])
		var options = {}
		
		for specialization in Global.arr.specialization:
			var token = get(specialization)
			
			if token.get_value() > 0:
				options[specialization] = token.get_value()
		
		while rolls["multiplier"] > 0:
			var specialization = Global.get_random_key(options)
			var token = get(specialization)
			var _max = min(token.get_value(), rolls["multiplier"])
			Global.rng.randomize()
			var value = Global.rng.randi_range(1, _max)
			rolls["multiplier"] -= value
			token.change_value(-value)
			
			if token.get_value() == 0:
				options.erase(specialization)


func update_impacts() -> void:
	var base = amplifier.get_value()
	
	for specialization in Global.arr.specialization:
		var multiplier = get(specialization)
		var value = multiplier.get_value()
		
		if value > 0:
			var donor = library.core.get(specialization)
			value *= donor.get_value() / 100.0
			base += floor(value)
	
	var dispersion = spread.get_value() / 2
	
	for impact in Global.arr.impact:
		var token = get(impact)
		var value = int(base)
		
		match impact:
			"minimum":
				value -= dispersion
			"maximum":
				pass
				value += dispersion
		
		token.set_value(value)
#endregion
