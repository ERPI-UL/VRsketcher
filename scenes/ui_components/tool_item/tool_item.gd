extends Control
class_name ToolItem

export(String) var target_tool_name : String = "TOOL_NAME";
export(Texture) var tool_icon : Texture = null;

func _ready() -> void :
	(get_node("MarginContainer/Button/VBoxContainer/Label") as Label).text = ToolsDatabase.get_tool_name(target_tool_name);
	(get_node("MarginContainer/Button/VBoxContainer/TextureRect") as TextureRect).texture = tool_icon;
	
	(get_node("MarginContainer/Button") as Button).connect("pressed", self, "select_tool");

func select_tool() -> void :
	EventBus.emit_signal("tool_switch_tool", target_tool_name);
	print("press")
