extends SketchTool
class_name Move

var start_position				: Vector3	= Vector3.ZERO;
var start_offset				: Vector3	= Vector3.ZERO;

onready var interaction_area	: Area		= get_node("Area");

func _ready() -> void :
	._ready();

func _physics_process(_delta : float) -> void :
	if tool_in_use == true :
		if interacted_object != null :
			var current_position : Vector3 = global_transform.origin;
			var base_model_position : Vector3 = start_position - start_offset;
			
			var move_distance : float = start_position.distance_to(current_position);
			var move_direction = start_position.direction_to(current_position);
			
			var direction : Vector3 = Vector3.ZERO;

			if move_direction.length() >= 0.01 :
				
				match (modes_main[mode_main_index] as String) :
					"Déplacement Libre" :
						direction = move_direction;
					"Déplacement X Global" :
						direction = Vector3.RIGHT;
					"Déplacement Y Global" :
						direction = Vector3.UP;
					"Déplacement Z Global" :
						direction = Vector3.FORWARD;
					"Déplacement X Local" :
						direction = interacted_object.global_transform.basis.x.normalized();
					"Déplacement Y Local" :
						direction = interacted_object.global_transform.basis.y.normalized();
					"Déplacement Z Local" :
						direction = interacted_object.global_transform.basis.z.normalized();
					_ :
						return;

				var direction_sign : float = sign(direction.dot(move_direction));

				if interacted_object is Model3D :
					(interacted_object as Model3D).set_position(base_model_position + move_distance * (direction * direction_sign))
				else :
					interacted_object.global_transform.origin = base_model_position + move_distance * (direction * direction_sign);

func load_tool_modes() -> void :
	.load_tool_modes();
	modes_main = [
		["Déplacement Libre"],
		
		["Déplacement X Global"],
		["Déplacement Y Global"],
		["Déplacement Z Global"],

		["Déplacement X Local"],
		["Déplacement Y Local"],
		["Déplacement Z Local"],
	];

	modes_sub = [
		[""]
	];

func start_tool_use() -> void :
	.start_tool_use();
	
	start_position = global_transform.origin;
	if interacted_object != null :
		start_offset = global_transform.origin - interacted_object.global_transform.origin;

func stop_tool_use() -> void :
	.stop_tool_use();
