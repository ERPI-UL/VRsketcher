extends SketchTool
class_name Teleport

export(NodePath)	var root_node_path			: NodePath		= "";
export(NodePath)	var camera_node_path		: NodePath		= "";
export(NodePath)	var teleport_gizmo_path		: NodePath		= "";

onready var root_node			: Spatial	= get_node(root_node_path);
onready var teleport_gizmo		: Spatial	= get_node(teleport_gizmo_path);
onready var camera_node			: Spatial	= get_node(camera_node_path);

onready var raycast				: RayCast	= get_node("RayCast");
onready var ray					: Spatial	= get_node("RayCast/RayGraphics");

var teleport_position			: Vector3	= Vector3.ZERO;

func _ready() -> void :
	_tool_mode_name = "Teleport";
	
	teleport_gizmo.get_parent().remove_child(teleport_gizmo);
	get_viewport().add_child(teleport_gizmo);

	raycast.visible = false;
	raycast.enabled = false;
	teleport_gizmo.visible = false;

func _physics_process(delta : float) -> void :
	if raycast.is_colliding() == true :
		teleport_position = raycast.get_collision_point();
		teleport_gizmo.global_transform.origin = teleport_position;
		
		ray.scale.y = raycast.global_transform.origin.distance_to(raycast.get_collision_point());

func start_tool_use() -> void :
	.start_tool_use();

	raycast.visible = true;
	raycast.enabled = true;
	teleport_gizmo.visible = true;

func stop_tool_use() -> void :
	.stop_tool_use();
	
	raycast.visible = false;
	raycast.enabled = false;
	teleport_gizmo.visible = false;

	var camera_offset : Vector3 = camera_node.translation;
	camera_offset.y = 0.0;

	if root_node != null :
		root_node.global_transform.origin = teleport_position - camera_offset;

func switch_tool_mode() -> void :
	.switch_tool_mode();
