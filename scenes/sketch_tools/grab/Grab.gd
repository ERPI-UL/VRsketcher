extends SketchTool
class_name Grab

var original_parent : Node3D = null;
var grabbed_object : Node3D = null;

@onready var interaction_area	: Area3D		= get_node("Area3D");

func _ready() -> void :
	super._ready();

func load_tool_modes() -> void :
	super.load_tool_modes();
	modes_main = [
		["Saisir"]
	];

	modes_sub = [
		[""]
	];

func start_tool_use() -> void :
	super.start_tool_use();

	if interacted_object != null :
		grabbed_object = interacted_object;
		original_parent = grabbed_object.get_parent();
		
		var original_transform : Transform3D = grabbed_object.global_transform;
		
		if original_parent != null :
			original_parent.remove_child(grabbed_object);
		add_child(grabbed_object);
		grabbed_object.global_transform = original_transform;

func stop_tool_use() -> void :
	super.stop_tool_use();
	
	if grabbed_object != null :
		var new_transform : Transform3D = grabbed_object.global_transform;
		remove_child(grabbed_object);
		if original_parent != null :
			original_parent.add_child(grabbed_object);
			grabbed_object.global_transform = new_transform;
