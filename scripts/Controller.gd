extends Spatial
class_name Controller

export(NodePath) var tools_path : NodePath = "";
onready var tools : Array = get_node(tools_path).get_children();

export(NodePath) var tooltip_path : NodePath = "";
onready var tooltip : ToolTip = get_node(tooltip_path);

var current_tool_index : int = -1;

func _ready() -> void :
	for t in tools :
		(t as SketchTool).hide_tool();
		(t as SketchTool).connect("tool_mode_switch", tooltip, "update_tooltip_text");
	switch_tool();

func switch_tool(switch_to_previous : bool = false) -> void :
	if current_tool_index >= 0 :
		get_current_tool().stop_tool_use();
		get_current_tool().hide_tool();

	if switch_to_previous == false :
		current_tool_index += 1;
		if current_tool_index >= tools.size() :
			current_tool_index = 0;
	else :
		current_tool_index -= 1;
		if current_tool_index < 0 :
			current_tool_index = tools.size() - 1;

	get_current_tool().show_tool();
	
	tooltip.update_tooltip_text(get_current_tool().get_tool_mode_name());

func switch_to_tool(var index : int = 0) -> void :
	if current_tool_index >= 0 :
		get_current_tool().stop_tool_use();
		get_current_tool().hide_tool();
	
	current_tool_index = clamp(index, 0, tools.size() - 1);
	get_current_tool().show_tool();
	
	tooltip.update_tooltip_text(get_current_tool().get_tool_mode_name());

func get_current_tool() -> SketchTool :

	return tools[current_tool_index];
