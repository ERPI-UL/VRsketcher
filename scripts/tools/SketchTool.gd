extends Spatial
class_name SketchTool

onready var INTERACTION_OVERLAY_MATERIAL : Material = load("res://materials/interaction_overlay_material.tres");

var tool_in_use			: bool		= false;

var _tool_mode_name		: String	= "";

var interacted_object			: Spatial	= null;

signal tool_mode_switch(tool_mode_name);

func start_tool_use() -> void :
	tool_in_use = true;

func stop_tool_use() -> void :
	tool_in_use = false

func switch_tool_mode() -> void :
	emit_signal("tool_mode_switch", _tool_mode_name);

func show_tool() -> void :
	visible = true;

func hide_tool() -> void :
	visible = false;

func get_tool_mode_name() -> String :
	return _tool_mode_name;


func object_enter_hover(node : Node) -> void :
	if tool_in_use == false && visible == true :
		if node is ModelInteractionArea == true :
			interacted_object = node.get_parent();
			if interacted_object is Model3D == true :
				(interacted_object as Model3D).set_overlay_material(INTERACTION_OVERLAY_MATERIAL);
		elif node is Area == true :
			interacted_object = node;

func object_exit_hover(node : Node) -> void :
	if node is ModelInteractionArea == true :
		if node.get_parent() == interacted_object :
			if interacted_object is Model3D == true :
				(interacted_object as Model3D).set_overlay_material(null);
			interacted_object = null;
