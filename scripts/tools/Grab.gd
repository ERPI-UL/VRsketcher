extends SketchTool
class_name Grab

var original_parent : Spatial = null;
var grabbed_object : Spatial = null;

onready var interaction_area	: Area		= get_node("Area");

func _ready() -> void :
	_tool_mode_name = "Grab";

func start_tool_use() -> void :
	.start_tool_use();

	if interacted_object != null :
		grabbed_object = interacted_object;
		original_parent = grabbed_object.get_parent();
		
		var original_transform : Transform = grabbed_object.global_transform;
		
		if original_parent != null :
			original_parent.remove_child(grabbed_object);
		add_child(grabbed_object);
		grabbed_object.global_transform = original_transform;

func switch_tool_mode(invert_switch : bool = false) -> void :
	.switch_tool_mode(invert_switch);

func stop_tool_use() -> void :
	.stop_tool_use();
	
	if grabbed_object != null :
		var new_transform : Transform = grabbed_object.global_transform;
		remove_child(grabbed_object);
		if original_parent != null :
			original_parent.add_child(grabbed_object);
			grabbed_object.global_transform = new_transform;
