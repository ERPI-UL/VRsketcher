extends Control
class_name ToolShortcut

@export var shortcut_direction : int = Enums.ShortcutDirection.UP; # (Enums.ShortcutDirection)
@export var arrow_icon: Texture2D = null;
@export var icon_tint_color: Color = Color.WHITE;

func _ready() -> void :
	(get_node("Button/Arrow_Icon") as TextureRect).texture = arrow_icon;

	(get_node("Button") as Button).connect("pressed", Callable(self, "set_shortcut"));
	
	Project.connect("open_project", Callable(self, "update_shortcut"));
	update_shortcut();

func set_shortcut() -> void :
	EventBus.emit_signal("tool_set_shortcut", shortcut_direction, self);

func update_shortcut() -> void :
	var shortcut_tool : String = "";
	match shortcut_direction :
		Enums.ShortcutDirection.UP :
			shortcut_tool = Project.current_project["tool_shortcut_up"];
		Enums.ShortcutDirection.DOWN :
			shortcut_tool = Project.current_project["tool_shortcut_down"];
		Enums.ShortcutDirection.LEFT :
			shortcut_tool = Project.current_project["tool_shortcut_left"];
		Enums.ShortcutDirection.RIGHT :
			shortcut_tool = Project.current_project["tool_shortcut_right"];

	set_icon(ToolsDatabase.get_tool_icon(shortcut_tool));
	set_label(ToolsDatabase.get_tool_name(shortcut_tool));

func set_icon(icon : Texture2D) -> void :
	(get_node("Button/VBoxContainer/MarginContainer/TextureRect") as TextureRect).texture = icon;

func set_label(label : String) -> void :
	(get_node("Button/VBoxContainer/Label") as Label).text = label;
