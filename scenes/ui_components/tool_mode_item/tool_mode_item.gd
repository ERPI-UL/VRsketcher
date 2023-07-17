extends Control
class_name ToolModeItem

enum TOOL_MODE_TYPE {
	MAIN = 0,
	SUB = 1
}

export(TOOL_MODE_TYPE) var mode_type : int = TOOL_MODE_TYPE.MAIN;

export(String) var tool_mode_name : String = "TOOL_MODE";
export(Texture) var tool_icon : Texture = null;

export(int) var target_mode_index : int = 0;
export(Color) var icon_tint_color : Color = Color.white;


func _ready() -> void :
	(get_node("Button/VBoxContainer/Label") as Label).text = tool_mode_name;
	(get_node("Button/VBoxContainer/MarginContainer/TextureRect") as TextureRect).texture = tool_icon;
	(get_node("Button/VBoxContainer/MarginContainer/TextureRect") as TextureRect).self_modulate = icon_tint_color;
	
	(get_node("Button") as Button).connect("pressed", self, "select_tool_mode");

func select_tool_mode() -> void :
	match mode_type :
		TOOL_MODE_TYPE.MAIN :
			EventBus.emit_signal("tool_main_mode_switch", target_mode_index);
		TOOL_MODE_TYPE.SUB :
			EventBus.emit_signal("tool_sub_mode_switch", target_mode_index);
