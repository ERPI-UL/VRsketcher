extends Spatial
class_name Controller

export(NodePath) var tools_root_path : NodePath = "";
onready var tools_root : Spatial = get_node(tools_root_path);

export(NodePath) var tooltip_path : NodePath = "";
onready var tooltip : Spatial = get_node(tooltip_path);

var current_tool : SketchTool = null;

func _ready() -> void :
	EventBus.connect("tool_switch_tool", self, "switch_to_tool");

	EventBus.connect("tool_main_mode_switch", self, "switch_to_tool_main_mode");
	EventBus.connect("tool_sub_mode_switch", self, "switch_to_tool_sub_mode");

func switch_to_tool(tool_name : String) -> void :
	var new_tool : SketchTool = ToolsDatabase.get_tool(tool_name);

	if new_tool == null :
		return;

	if current_tool != null :
		current_tool.stop_tool_use();
		tools_root.remove_child(current_tool);

	current_tool = new_tool;
	tools_root.add_child(new_tool);

	EventBus.emit_signal("tooltip_update_text", ToolsDatabase.get_tool_name(tool_name));

func switch_to_tool_main_mode(tool_mode : int) -> void :
	print("switch main")
	if current_tool != null :
		current_tool.set_tool_main_mode(tool_mode);

func switch_to_tool_sub_mode(tool_mode : int) -> void :
	print("switch sub")
	if current_tool != null :
		current_tool.set_tool_sub_mode(tool_mode);
