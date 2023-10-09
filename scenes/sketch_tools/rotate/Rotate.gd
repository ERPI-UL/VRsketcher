extends SketchTool
class_name Rotate

var modes	: Array		= [
	"Free"
];

var center_position				: Vector3	= Vector3.ZERO;
var start_position				: Vector3	= Vector3.ZERO;
var end_position				: Vector3	= Vector3.ZERO;

var base_object_rotation		: Basis		= Basis.IDENTITY;
var base_tool_rotation			: Basis		= Basis.IDENTITY;
var current_tool_rotation		: Basis		= Basis.IDENTITY;

onready var interaction_area	: Area		= get_node("Area");

func _ready() -> void :
	._ready();

func _physics_process(_delta : float) -> void :
	if tool_in_use == true :
		match (modes[mode_main_index] as String) :
			"Rotation Libre" :
				current_tool_rotation = global_transform.basis;
				if interacted_object != null :
					interacted_object.global_transform.basis = current_tool_rotation * base_tool_rotation.inverse() * base_object_rotation;
			_ :
				pass;

func load_tool_modes() -> void :
	.load_tool_modes();
	modes_main = [
		["Rotation Libre"],
		
		["Rotation X Global"],
		["Rotation Y Global"],
		["Rotation Z Global"],

		["Rotation X Local"],
		["Rotation Y Local"],
		["Rotation Z Local"],
	];

	modes_sub = [
		[""]
	];


func start_tool_use() -> void :
	.start_tool_use();

	if interacted_object != null :
		base_object_rotation = interacted_object.global_transform.basis;
		base_tool_rotation = global_transform.basis;

func stop_tool_use() -> void :
	.stop_tool_use();
