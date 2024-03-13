extends Control
class_name ToolItem

@export var target_tool_name: String = "TOOL_NAME";
@export var tool_icon: Texture2D = null;
@export var icon_tint_color: Color = Color.WHITE;

@onready var label : Label = get_node("Button/VBoxContainer/Label") as Label;
@onready var icon : TextureRect = get_node("Button/VBoxContainer/MarginContainer/TextureRect") as TextureRect;

signal tool_item_hovered(tool_name);

func _ready() -> void :
	label.text = ToolsDatabase.get_tool_name(target_tool_name);
	icon.texture = tool_icon;
	icon.self_modulate = icon_tint_color;
	
	(get_node("Button") as Button).connect("pressed", Callable(self, "select_tool"));

func select_tool() -> void :
	EventBus.emit_signal("tool_switch_tool", target_tool_name);

func tool_item_hover_entered() -> void :
	EventBus.emit_signal("tools_menu_tooltip_update_text", label.text);
