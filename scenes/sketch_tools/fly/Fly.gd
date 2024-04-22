extends SketchTool
class_name Fly

export(float) var fly_speed : float = 0.5;

var is_flying : bool = false;

var root_node : Spatial = null;

func _ready() -> void :
	._ready();

func load_tool_modes() -> void :
	.load_tool_modes();
	modes_main = [
		["Déplacement libre"]
	];

	modes_sub = [
		[""]
	];

func _physics_process(delta : float) -> void :
	if is_flying == true :
		var fly_direction : Vector3 = -global_transform.basis.z;

		if root_node != null :
			root_node.global_transform.origin += fly_direction * fly_speed * delta;
			root_node.global_transform.origin.y = max(root_node.global_transform.origin.y, 0.0);

func start_tool_use() -> void :
	.start_tool_use();

	if root_node == null :
		root_node = self;
		while (root_node is Controller) == false :
			root_node = root_node.get_parent();
			if root_node == null :
				return;

	is_flying = true;

func stop_tool_use() -> void :
	.stop_tool_use();
	is_flying = false;
