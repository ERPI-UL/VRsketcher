extends Node
class_name TooltipHovering

var label : Label = null;
func _ready():
	if get_parent() is Label :
		label = get_parent() as Label;

func update_tooltip() -> void :
	EventBus.emit_signal("tools_menu_tooltip_update_text", label.text);
