extends SketchTool
class_name Rotate

var modes	: Array		= [
	"Free"
];

export(Material)	var interaction_overlay_material	: Material		= null;

var current_mode				: int		= -1;
var interacted_object			: Spatial	= null;


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

func switch_tool_mode() -> void :
	current_mode += 1;
	if current_mode >= modes.size() :
		current_mode = 0;

	_tool_mode_name = (modes[current_mode] as String) + " Rotation";

	.switch_tool_mode();

func object_enter_hover(node : Node) -> void :
	if tool_in_use == false && visible == true :
		if node is ModelInteractionArea == true :
			interacted_object = node.get_parent();
			if interacted_object is Model3D == true :
				(interacted_object as Model3D).set_overlay_material(interaction_overlay_material);
		elif node is Area == true :
			interacted_object = node;

func object_exit_hover(node : Node) -> void :
	if node is ModelInteractionArea == true :
		if node.get_parent() == interacted_object :
			if interacted_object is Model3D == true :
				(interacted_object as Model3D).set_overlay_material(null);
			interacted_object = null;

