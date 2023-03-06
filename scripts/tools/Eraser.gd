extends SketchTool
class_name Eraser

var is_erasing : bool = false;

func _ready() -> void :
	_tool_mode_name = "Eraser";

func start_tool_use() -> void :
	.start_tool_use();
	if is_erasing == false :
		is_erasing = true;
		
func stop_tool_use() -> void :
	.stop_tool_use();
	if is_erasing == true :
		is_erasing = false;

func switch_tool_mode() -> void :
	.switch_tool_mode();

func erase_line(node : Node) -> void :
	if is_erasing == true :
		if node.get_parent() != null :
			if node.get_parent() is Line :
				node.get_parent().queue_free();
