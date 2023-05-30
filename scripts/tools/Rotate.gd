extends SketchTool
class_name Rotate

var modes	: Array		= [
	"Free"
];

var current_mode				: int		= -1;


var center_position				: Vector3	= Vector3.ZERO;
var start_position				: Vector3	= Vector3.ZERO;
var end_position				: Vector3	= Vector3.ZERO;

var base_object_rotation		: Basis		= Basis.IDENTITY;
var base_tool_rotation			: Basis		= Basis.IDENTITY;
var current_tool_rotation		: Basis		= Basis.IDENTITY;

onready var interaction_area	: Area		= get_node("Area");

func _ready() -> void :
	_tool_mode_name = "Rotation";
	switch_tool_mode();

func _physics_process(_delta : float) -> void :
	if tool_in_use == true :
		match (modes[current_mode] as String) :
			"Free" :
				current_tool_rotation = global_transform.basis;
				if interacted_object != null :
					interacted_object.global_transform.basis = current_tool_rotation * base_tool_rotation.inverse() * base_object_rotation;
			_ :
				pass;

func start_tool_use() -> void :
	.start_tool_use();

	if interacted_object != null :
		base_object_rotation = interacted_object.global_transform.basis;
		base_tool_rotation = global_transform.basis;

func stop_tool_use() -> void :
	.stop_tool_use();

func switch_tool_mode(invert_switch : bool = false) -> void :
	if invert_switch == true :
		current_mode -= 1;
		if current_mode < 0 :
			current_mode = modes.size() - 1;
	else :
		current_mode += 1;
		if current_mode >= modes.size() :
			current_mode = 0;

	_tool_mode_name = (modes[current_mode] as String) + " Rotation";

	.switch_tool_mode(invert_switch);
