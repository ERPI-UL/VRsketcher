extends Control
class_name ToolModeItem

export(Enums.ToolModeType) var mode_type : int = Enums.ToolModeType.MAIN;

export(String) var tool_mode_name : String = "TOOL_MODE";
export(Texture) var tool_icon : Texture = null;

export(int) var target_mode_index : int = 0;
export(Color) var icon_tint_color : Color = Color.white;

onready var label : Label = get_node("Button/VBoxContainer/Label") as Label;
onready var icon : TextureRect = get_node("Button/VBoxContainer/MarginContainer/TextureRect") as TextureRect;

func _ready() -> void :
	label.text = tool_mode_name;
	icon.texture = tool_icon;
	icon.self_modulate = icon_tint_color;
	
	(get_node("Button") as Button).connect("pressed", self, "select_tool_mode");

func select_tool_mode() -> void :
	match mode_type :
		Enums.ToolModeType.MAIN :
			EventBus.emit_signal("tool_main_mode_switch", target_mode_index);
		Enums.ToolModeType.SUB :
			EventBus.emit_signal("tool_sub_mode_switch", target_mode_index);
