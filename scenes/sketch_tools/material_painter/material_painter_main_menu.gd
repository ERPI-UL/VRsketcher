extends Control

onready var root : Control = get_node("GridContainer");

func _ready():
	var template : PackedScene = load("res://scenes/ui_components/tool_mode_item/ToolModeItem.tscn"); 

	var i = 0;
	for m in MaterialLibrary.materials :
		var item : ToolModeItem = template.instance();
		root.add_child(item);
		item.label.visible = false;
		item.icon.texture = (m as SpatialMaterial).albedo_texture;
		item.mode_type = Enums.ToolModeType.SUB;
		item.tool_mode_name = (m as SpatialMaterial).resource_name;
		item.target_mode_index = i;
		i += 1;
