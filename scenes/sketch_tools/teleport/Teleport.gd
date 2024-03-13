extends SketchTool
class_name Teleport

#@export(NodePath)	var teleport_gizmo_path		: NodePath		= "";
@export()	var teleport_gizmo_path		: NodePath		= "";

@onready var teleport_gizmo		: Node3D	= get_node(teleport_gizmo_path);

@onready var raycast				: RayCast3D	= get_node("RayCast3D");
@onready var ray					: Node3D	= get_node("RayCast3D/RayGraphics");

var teleport_position			: Vector3	= Vector3.ZERO;

func _ready() -> void :
	super._ready();

	teleport_gizmo.get_parent().remove_child(teleport_gizmo);
	get_viewport().add_child(teleport_gizmo);

	raycast.visible = false;
	raycast.enabled = false;
	teleport_gizmo.visible = false;


func _physics_process(_delta : float) -> void :
	if raycast.is_colliding() == true :
		teleport_position = lerp(teleport_position, raycast.get_collision_point(), 0.5);
		teleport_gizmo.global_transform.origin = teleport_position;

		ray.scale.y = raycast.global_transform.origin.distance_to(raycast.get_collision_point());

func load_tool_modes() -> void :
	super.load_tool_modes();
	modes_main = [
		["Teleportation"]
	];

	modes_sub = [
		[""]
	];

func start_tool_use() -> void :
	super.start_tool_use();

	raycast.visible = true;
	raycast.enabled = true;
	teleport_gizmo.visible = true;

func stop_tool_use() -> void :
	super.stop_tool_use();

	raycast.visible = false;
	raycast.enabled = false;
	teleport_gizmo.visible = false;

	var root_node : Node = self;
	while (root_node is Controller) == false :
		root_node = root_node.get_parent();
		if root_node == null :
			return;

	var camera_node : Camera3D = null;
	for c in get_children_recursive(root_node) :
		if c is Camera3D :
			camera_node = c;
			break;

	var camera_offset : Vector3 = camera_node.position;
	camera_offset.y = 0.0;

	if root_node != null :
		root_node.global_transform.origin = teleport_position - camera_offset;

func get_children_recursive (root : Node) -> Array :
	var children : Array = [];
	for child in root.get_children():
		children.append(child);
		if child.get_child_count() > 0 :
			children.append_array(get_children_recursive(child));
	return children;
