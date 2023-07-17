extends SketchTool
class_name Grab

var original_parent : Spatial = null;
var grabbed_object : Spatial = null;

onready var interaction_area	: Area		= get_node("Area");

func _ready() -> void :
	._ready();

func load_tool_modes() -> void :
	.load_tool_modes();
	modes_main = [
		["Saisir"]
	];

	modes_sub = [
		[""]
	];

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

func stop_tool_use() -> void :
	.stop_tool_use();
	
	if grabbed_object != null :
		var new_transform : Transform = grabbed_object.global_transform;
		remove_child(grabbed_object);
		if original_parent != null :
			original_parent.add_child(grabbed_object);
			grabbed_object.global_transform = new_transform;
