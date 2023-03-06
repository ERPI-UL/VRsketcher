extends SketchTool
class_name Rotate

var modes : Array = [
	"Free",
	"X_Global",
	"Y_Global",
	"Z_Global",
	"X_Local",
	"Y_Local",
	"Z_Local"
];

export(Material) var interaction_overlay_material : Material = null;

var current_mode : int = -1;
var interacted_object : Spatial = null;
var start_position : Vector3 = Vector3.ZERO;

onready var interaction_area : Area = get_node("Area");

func _ready() -> void :
	_tool_mode_name = "Rotation";
	switch_tool_mode();

func _physics_process(_delta : float) -> void :
	if tool_in_use == true :
		match (modes[current_mode] as String) :
			"Free" :
				pass;
			"X_Global" :
				pass;
			"Y_Global" :
				pass;
			"Z_Global" :
				pass;
			"X_Local" :
				pass;
			"Y_Local" :
				pass;
			"Z_Local" :
				pass;
			_ :
				pass;

func start_tool_use() -> void :
	.start_tool_use();

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
			if interacted_object is MeshInstance == true :
				(interacted_object as MeshInstance).material_overlay = interaction_overlay_material;

func object_exit_hover(node : Node) -> void :
	if node is ModelInteractionArea == true :
		if node.get_parent() == interacted_object :
			if interacted_object is MeshInstance == true :
				(interacted_object as MeshInstance).material_overlay = null;
			interacted_object = null;

	
