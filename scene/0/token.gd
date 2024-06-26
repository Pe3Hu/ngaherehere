extends MarginContainer


#region vars
@onready var bg = $BG
@onready var designation = $Designation
@onready var value = $Value

var proprietor = null
var type = null
var subtype = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	proprietor = input_.proprietor
	type = input_.type
	subtype = input_.subtype
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	init_bg()
	var exceptions = []
	
	if exceptions.has(type):
		custom_minimum_size = Vector2(Global.vec.size[type])
		size = custom_minimum_size
		designation.visible = false
	else:
		custom_minimum_size = Vector2(Global.vec.size.token)
	
	init_tokens()
	
	if input_.has("value"):
		value.set_number(input_.value)
		value.visible = true
	
	value.custom_minimum_size = Vector2(Global.vec.size.token)
	
	var font_size = Global.dict.font.size.basic
	
	if Global.dict.font.size.has(type):
		font_size = Global.dict.font.size[type]
	
	value.number.set("theme_override_font_sizes/font_size", font_size)
	
	if !input_.has("value"):
		value.visible = false


func init_tokens() -> void:
	var input = {}
	input.type = type
	input.subtype = subtype
	designation.set_attributes(input)
	
	input.type = "number"
	input.subtype = 0
	
	value.set_attributes(input)
	value.visible = false


func init_bg() -> void:
	var style = StyleBoxFlat.new()
	style.bg_color = Color.SLATE_GRAY
	bg.set("theme_override_styles/panel", style)


func set_bg_color(color_: Color) -> void:
	var style = bg.get("theme_override_styles/panel")
	style.bg_color = color_
	
	if !bg.visible:
		bg.visible = true
#endregion


#region value treatment
func get_value() -> Variant:
	return value.get_number()


func change_value(value_: Variant) -> void:
	value.change_number(value_)
	
	if !value.visible:
		value.visible = true


func set_value(value_: Variant) -> void:
	value.set_number(value_)
	
	if !value.visible:
		value.visible = true


func multiply_value(multiplier_: Variant) -> void:
	var _value = get_value() * multiplier_
	value.set_number(_value)
#endregion


func set_subtype(subtype_: String) -> void:
	subtype = subtype_
	designation.subtype = subtype
	designation.update_image()


func set_type_and_subtype(type_: String, subtype_: String) -> void:
	type = type_
	designation.type = type
	subtype = subtype_
	designation.subtype = subtype
	designation.update_image()


func replicate(token_: MarginContainer) -> void:
	set_type_and_subtype(token_.designation.type, token_.designation.subtype)
	init_tokens()
	
	if token_.bg.visible:
		init_bg()
		var style = token_.bg.get("theme_override_styles/panel")
		set_bg_color(style.bg_color)
	
	if token_.value.visible:
		set_value(token_.get_value())
		value.visible = true
	
	visible = token_.visible
	custom_minimum_size = token_.custom_minimum_size
