extends Area
class_name VRToolItem

export(int) var target_tool_index : int = 0;
export(Texture) var tool_icon : Texture = null;
export(String) var tool_name : String = "TOOL NAME";

var base_blink_speed : float = 1.0;

onready var icon_material : ShaderMaterial = load("res://materials/vr_tool_item.tres").duplicate();

signal item_selected();

func _ready() -> void :
	(get_node("Label3D") as Label3D).text = tool_name;
	
	(get_node("Graphics") as MeshInstance).material_override = icon_material;
	
	base_blink_speed = icon_material.get_shader_param("blink_speed");
	
	icon_material.set_shader_param("icon_texture", tool_icon);
	icon_material.set_shader_param("blink_speed", 0.0);

func focus_entered() -> void :
	icon_material.set_shader_param("blink_speed", base_blink_speed);
	
func focus_exited() -> void :
	icon_material.set_shader_param("blink_speed", 0.0);
