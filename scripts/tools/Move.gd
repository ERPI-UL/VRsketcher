extends SketchTool
class_name Move

var modes	: Array		= [
	"Free",
	"X Global",
	"Y Global",
	"Z Global",
	"X Local",
	"Y Local",
	"Z Local"
];

export(Material) var interaction_overlay_material	: Material	= null;

var current_mode				: int		= -1;
var interacted_object			: Spatial	= null;
var start_position				: Vector3	= Vector3.ZERO;
var start_offset				: Vector3	= Vector3.ZERO;

onready var interaction_area	: Area		= get_node("Area");

func _ready() -> void :
	_tool_mode_name = "Move";
	switch_tool_mode();

func _physics_process(_delta : float) -> void :
	if tool_in_use == true :
		if interacted_object != null :
			var current_position : Vector3 = global_transform.origin;
			var base_model_position : Vector3 = start_position - start_offset;
			
			var move_distance : float = start_position.distance_to(current_position);
			var move_direction = start_position.direction_to(current_position);
			
			var direction : Vector3 = Vector3.ZERO;

			if move_direction.length() >= 0.01 :
				
				match (modes[current_mode] as String) :
					"Free" :
						direction = move_direction;
					"X Global" :
						direction = Vector3.RIGHT;
					"Y Global" :
						direction = Vector3.UP;
					"Z Global" :
						direction = Vector3.FORWARD;
					"X Local" :
						direction = interacted_object.global_transform.basis.x.normalized();
					"Y Local" :
						direction = interacted_object.global_transform.basis.y.normalized();
					"Z Local" :
						direction = interacted_object.global_transform.basis.z.normalized();
					_ :
						return;

				var direction_sign : float = sign(direction.dot(move_direction));

				if interacted_object is Model3D :
					(interacted_object as Model3D).set_position(base_model_position + move_distance * (direction * direction_sign))
				else :
					interacted_object.global_transform.origin = base_model_position + move_distance * (direction * direction_sign);

func start_tool_use() -> void :
	.start_tool_use();
	
	start_position = global_transform.origin;
	if interacted_object != null :
		start_offset = global_transform.origin - interacted_object.global_transform.origin;

func stop_tool_use() -> void :
	.stop_tool_use();

func switch_tool_mode() -> void :
	current_mode += 1;
	if current_mode >= modes.size() :
		current_mode = 0;

	_tool_mode_name = (modes[current_mode] as String) + " Move";

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
