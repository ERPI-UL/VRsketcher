extends Node3D
class_name SketchTool

@onready var INTERACTION_OVERLAY_MATERIAL : Material = load("res://materials/interaction_overlay_material.tres");

var tool_in_use			: bool		= false;
var interacted_object	: Node3D	= null;

var mode_main_index		: int		= 0;
var mode_sub_index		: int		= 0;

var modes_main			: Array		= [
	[""]
];
var modes_sub			: Array		= [
	[""]
];

func _ready() -> void :
	load_tool_modes();

func load_tool_modes() -> void :
	pass;

func start_tool_use() -> void :
	tool_in_use = true;

func stop_tool_use() -> void :
	tool_in_use = false
	
func set_tool_main_mode(mode_index : int) -> void :
	mode_main_index = mode_index;
	EventBus.call_deferred("emit_signal", "tooltip_update_text", get_tool_mode_name());

func set_tool_sub_mode(mode_index : int) -> void :
	mode_sub_index = mode_index;
	EventBus.call_deferred("emit_signal", "tooltip_update_text", get_tool_mode_name(true));

func show_tool(tool_visible : bool = true) -> void :
	visible = tool_visible;

func get_tool_mode_name(get_sub_mode_name : bool = false) -> String :
	if get_sub_mode_name == true :
		return modes_sub[mode_sub_index][0] as String;
	return modes_main[mode_main_index][0] as String;

func object_enter_hover(node : Node) -> void :
	if tool_in_use == false && visible == true :
		if node is ModelInteractionArea == true :
			interacted_object = node.get_parent();
			if interacted_object is Model3D == true :
				(interacted_object as Model3D).set_overlay_material(INTERACTION_OVERLAY_MATERIAL);
		elif node is Area3D == true :
			interacted_object = node;

func object_exit_hover(node : Node) -> void :
	if node is ModelInteractionArea == true :
		if node.get_parent() == interacted_object :
			if interacted_object is Model3D == true :
				(interacted_object as Model3D).set_overlay_material(null);
			interacted_object = null;
