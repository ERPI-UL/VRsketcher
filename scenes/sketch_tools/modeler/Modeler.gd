extends SketchTool
class_name Modeler

var modes	: Array		= [
	"Box",
	"Cube",
	"Sphere",
	"Cylinder",
	"Cone",
	"Torus"
];

var start_position						: Vector3		= Vector3.ZERO;
var end_position						: Vector3		= Vector3.ZERO;
var reference_right_direction			: Vector3		= Vector3.RIGHT;
var reference_forward_direction			: Vector3		= Vector3.FORWARD;

var current_model						: Model3D		= null;

onready var tool_gizmo					: Spatial		= get_node("Graphics/Gizmo_Position");

func _ready() -> void :
	._ready();

func _physics_process(_delta : float) -> void :
	if tool_in_use == true :
		if current_model != null :
			end_position = tool_gizmo.global_transform.origin;
			
			current_model.global_transform.origin = (start_position + end_position) / 2.0;

			current_model.look_at(current_model.global_transform.origin + reference_forward_direction, Vector3.UP);
			
			var draw_vector : Vector3 = end_position - start_position;
			var draw_vector_length : float = draw_vector.length();

			match (modes[mode_main_index] as String) :
				"Box" :
					(current_model.meshes[0] as CubeMesh).size.x = abs(draw_vector_length * cos(reference_right_direction.angle_to(draw_vector)));
					(current_model.meshes[0] as CubeMesh).size.y = abs(end_position.y - start_position.y);
					(current_model.meshes[0] as CubeMesh).size.z = abs(draw_vector_length * cos(reference_forward_direction.angle_to(draw_vector)));
				"Cube" :
					(current_model.meshes[0] as CubeMesh).size = Vector3.ONE * (draw_vector_length / sqrt(3.0));
				"Sphere" :
					(current_model.meshes[0] as SphereMesh).height = draw_vector_length;
					(current_model.meshes[0] as SphereMesh).radius = draw_vector_length / 2.0;
					
				"Cylinder" :
					(current_model.meshes[0] as CylinderMesh).top_radius = abs(draw_vector_length * (end_position - start_position).dot(reference_right_direction));
					(current_model.meshes[0] as CylinderMesh).height = abs(end_position.y - start_position.y);
					(current_model.meshes[0] as CylinderMesh).bottom_radius = (current_model.meshes[0] as CylinderMesh).top_radius;
				"Cone" :
					(current_model.meshes[0] as CylinderMesh).top_radius = 0.0;
					(current_model.meshes[0] as CylinderMesh).height = abs(end_position.y - start_position.y);
					(current_model.meshes[0] as CylinderMesh).bottom_radius = abs(draw_vector_length * (end_position - start_position).dot(reference_right_direction));


				_ :
					pass;

func load_tool_modes() -> void :
	.load_tool_modes();
	modes_main = [
		["Box"],
		["Cube"],
		["Sphere"],
		["Cylinder"],
		["Cone"],
		["Torus"]
	];

	modes_sub = [
		[""]
	];

func start_tool_use() -> void :
	.start_tool_use();

	start_position = tool_gizmo.global_transform.origin;
	end_position = tool_gizmo.global_transform.origin;
	
	reference_right_direction = CameraData.direction_right;
	reference_right_direction.y = 0.0;
	reference_right_direction = reference_right_direction.normalized();
	
	reference_forward_direction = CameraData.direction_forward;
	reference_forward_direction.y = 0.0;
	reference_forward_direction = reference_forward_direction.normalized();

	current_model = Model3D.new();
	current_model.inspector_name = "";
	match (modes[mode_main_index] as String) :
		"Box" :
			current_model.model_filename = "Box";
			current_model.inspector_name = "Box";
			current_model.add_mesh(CubeMesh.new());
			(current_model.meshes[0] as CubeMesh).size = Vector3.ONE * 0.05;
		"Cube" :
			current_model.model_filename = "Cube";
			current_model.inspector_name = "Cube";
			current_model.add_mesh(CubeMesh.new());
			(current_model.meshes[0] as CubeMesh).size = Vector3.ONE * 0.05;
		"Sphere" :
			current_model.model_filename = "Sphere";
			current_model.inspector_name = "Sphere";
			current_model.add_mesh(SphereMesh.new());
			(current_model.meshes[0] as SphereMesh).height = 0.05;
			(current_model.meshes[0] as SphereMesh).radius = 0.025;
			(current_model.meshes[0] as SphereMesh).radial_segments = 32;
			(current_model.meshes[0] as SphereMesh).rings = 16;
		"Cylinder" :
			current_model.model_filename = "Cylinder";
			current_model.inspector_name = "Cylinder";
			current_model.add_mesh(CylinderMesh.new());
			(current_model.meshes[0] as CylinderMesh).top_radius = 0.05;
			(current_model.meshes[0] as CylinderMesh).height = 0.1;
			(current_model.meshes[0] as CylinderMesh).bottom_radius = 0.05;
			(current_model.meshes[0] as CylinderMesh).radial_segments = 16;
			(current_model.meshes[0] as CylinderMesh).rings = 1;
		"Cone" :
			current_model.model_filename = "Cone";
			current_model.inspector_name = "Cone";
			current_model.add_mesh(CylinderMesh.new());
			(current_model.meshes[0] as CylinderMesh).top_radius = 0.0;
			(current_model.meshes[0] as CylinderMesh).height = 0.1;
			(current_model.meshes[0] as CylinderMesh).bottom_radius = 0.05;
			(current_model.meshes[0] as CylinderMesh).radial_segments = 16;
			(current_model.meshes[0] as CylinderMesh).rings = 1;
		_ :
			pass;
	
	(get_tree().root.get_node("VRSketcher") as VRSketcher).scene_drawn_models.add_child(current_model);

func stop_tool_use() -> void :
	.stop_tool_use();
	
	if current_model != null :
		if start_position.distance_to(end_position) < 0.01 :
			current_model.queue_free();
		else :
			current_model.update_aabb();
			current_model.update_interaction_area();

			var manager : ModelsManager = (get_tree().root.get_node("VRSketcher") as VRSketcher).manager_drawn_models;
			manager.add_model(current_model);
			EventBus.emit_signal("scene_drawn_models_list_updated", manager.models, manager);

		current_model = null;
