extends Spatial
class_name SketchTool

var tool_in_use			: bool		= false;

var _tool_mode_name		: String	= "";

signal tool_mode_switch(tool_mode_name);

func start_tool_use() -> void :
	tool_in_use = true;

func stop_tool_use() -> void :
	tool_in_use = false

func switch_tool_mode() -> void :
	emit_signal("tool_mode_switch", _tool_mode_name);

func show_tool() -> void :
	visible = true;

func hide_tool() -> void :
	visible = false;

func get_tool_mode_name() -> String :
	return _tool_mode_name;
