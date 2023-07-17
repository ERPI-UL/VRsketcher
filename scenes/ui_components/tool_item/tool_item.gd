extends Control
class_name ToolItem

export(String) var target_tool_name : String = "TOOL_NAME";
export(Texture) var tool_icon : Texture = null;
export(Color) var icon_tint_color : Color = Color.white;

func _ready() -> void :
	(get_node("Button/VBoxContainer/Label") as Label).text = ToolsDatabase.get_tool_name(target_tool_name);
	(get_node("Button/VBoxContainer/MarginContainer/TextureRect") as TextureRect).texture = tool_icon;
	(get_node("Button/VBoxContainer/MarginContainer/TextureRect") as TextureRect).self_modulate = icon_tint_color;
	
	(get_node("Button") as Button).connect("pressed", self, "select_tool");

func select_tool() -> void :
	EventBus.emit_signal("tool_switch_tool", target_tool_name);
