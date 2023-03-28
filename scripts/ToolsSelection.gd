extends SketchTool
class_name ToolsSelection

export(NodePath)	var controller_path			: NodePath		= "";
export(NodePath)	var vr_tools_menu_path		: NodePath		= "";

onready var controller			: Node			= get_node(controller_path);
onready var vr_tools_menu		: Spatial		= get_node(vr_tools_menu_path);
onready var raycast				: RayCast		= get_node("RayCast");
onready var ray					: Spatial		= get_node("RayCast/RayGraphics");

var tool_index : int = -1;
var tool_item : VRToolItem = null;

func _ready() -> void :
	_tool_mode_name = "Tool selection";

	raycast.visible = false;
	raycast.enabled = false;
	
	
	vr_tools_menu.visible = false;

func _physics_process(delta : float) -> void :
	if raycast.is_colliding() == true :
		if raycast.get_collider() is VRToolItem :
			var item : VRToolItem = raycast.get_collider();
			
			if item != tool_item :
				tool_item.focus_exited();
			
			tool_index = item.target_tool_index;
			tool_item = item;
			tool_item.focus_entered();
		else :
			if tool_item != null :
				tool_item.focus_exited();
				tool_item = null;
			tool_index = -1;
		ray.scale.y = raycast.global_transform.origin.distance_to(raycast.get_collision_point());
	else :
		tool_index = -1;
		if tool_item != null :
			tool_item.focus_exited();
			tool_item = null;


func start_tool_use() -> void :
	.start_tool_use();

	raycast.visible = true;
	raycast.enabled = true;
	
	vr_tools_menu.visible = true;

func stop_tool_use() -> void :
	.stop_tool_use();
	
	raycast.visible = false;
	raycast.enabled = false;
	
	vr_tools_menu.visible = false;

	if controller != null :
		controller.switch_to_tool(tool_index);

func switch_tool_mode() -> void :
	.switch_tool_mode();
