extends Node3D
class_name Controller

@export var tools_root_path: NodePath = "";
@onready var tools_root : Node3D = get_node(tools_root_path);

@export var tooltip_path: NodePath = "";
@onready var tooltip : Node3D = get_node(tooltip_path);

var current_tool : SketchTool = null;
var current_tool_name : String = "";

func _ready() -> void :
	EventBus.connect("tool_switch_tool", Callable(self, "switch_to_tool"));

	EventBus.connect("tool_main_mode_switch", Callable(self, "switch_to_tool_main_mode"));
	EventBus.connect("tool_sub_mode_switch", Callable(self, "switch_to_tool_sub_mode"));
	
	EventBus.connect("tool_set_shortcut", Callable(self, "set_tool_shortcut"));

func switch_to_tool(tool_name : String) -> void :
	var new_tool : SketchTool = ToolsDatabase.get_tool(tool_name);

	if new_tool == null :
		return;

	if current_tool != null :
		current_tool.stop_tool_use();
		tools_root.remove_child(current_tool);

	current_tool = new_tool;
	current_tool_name = tool_name;
	tools_root.add_child(new_tool);

	EventBus.emit_signal("tooltip_update_text", ToolsDatabase.get_tool_name(tool_name));
	
func switch_to_shortcut(shortcut_direction : int) -> void :
	match shortcut_direction :
		Enums.ShortcutDirection.UP :
			EventBus.emit_signal("tool_switch_tool", Project.current_project["tool_shortcut_up"]);
		Enums.ShortcutDirection.DOWN :
			EventBus.emit_signal("tool_switch_tool", Project.current_project["tool_shortcut_down"]);
		Enums.ShortcutDirection.LEFT :
			EventBus.emit_signal("tool_switch_tool", Project.current_project["tool_shortcut_left"]);
		Enums.ShortcutDirection.RIGHT :
			EventBus.emit_signal("tool_switch_tool", Project.current_project["tool_shortcut_right"]);


func set_tool_shortcut(shortcut_direction : int, shortcut_button : ToolShortcut) -> void :
	match shortcut_direction :
		Enums.ShortcutDirection.UP :
			Project.current_project["tool_shortcut_up"] = current_tool_name;
		Enums.ShortcutDirection.DOWN :
			Project.current_project["tool_shortcut_down"] = current_tool_name;
		Enums.ShortcutDirection.LEFT :
			Project.current_project["tool_shortcut_left"] = current_tool_name;
		Enums.ShortcutDirection.RIGHT :
			Project.current_project["tool_shortcut_right"] = current_tool_name;

	shortcut_button.set_icon(ToolsDatabase.get_tool_icon(current_tool_name));
	shortcut_button.set_label(ToolsDatabase.get_tool_name(current_tool_name));

func switch_to_tool_main_mode(tool_mode : int) -> void :
	if current_tool != null :
		current_tool.set_tool_main_mode(tool_mode);

func switch_to_tool_sub_mode(tool_mode : int) -> void :
	if current_tool != null :
		current_tool.set_tool_sub_mode(tool_mode);
