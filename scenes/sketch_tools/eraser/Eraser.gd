extends SketchTool
class_name Eraser

var is_erasing : bool = false;

func _ready() -> void :
	super._ready();

func load_tool_modes() -> void :
	super.load_tool_modes();
	modes_main = [
		["Effacer"]
	];

	modes_sub = [
		[""]
	];

func start_tool_use() -> void :
	super.start_tool_use();
	is_erasing = true;

func stop_tool_use() -> void :
	super.stop_tool_use();
	is_erasing = false;

func erase_line(node : Node) -> void :
	if is_erasing == true :
		if node.get_parent() != null :
			if node.get_parent() is Line :
				node.get_parent().queue_free();
			if node.get_parent() is Measurement :
				node.get_parent().queue_free();
			if node.get_parent() is Model3D :
				if (node.get_parent() as Model3D).is_imported == true :
					(get_tree().root.get_node("VRSketcher") as VRSketcher).manager_imported_models.remove_model((node.get_parent() as Model3D));
				else :
					(get_tree().root.get_node("VRSketcher") as VRSketcher).manager_drawn_models.remove_model((node.get_parent() as Model3D));
				node.get_parent().queue_free();
