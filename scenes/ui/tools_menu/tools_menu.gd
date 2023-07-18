extends Control

onready var tools_main_menu_root : Control = get_node("CenterContainer/VBoxContainer/tool_menus/main_menu");
onready var tools_sub_menu_root : Control = get_node("CenterContainer/VBoxContainer/tool_menus/sub_menu");

func _ready():
	EventBus.connect("tool_switch_tool", self, "update_tool_menus");

func update_tool_menus(tool_name : String) -> void :	
	#Clean previous menus
	for c in tools_main_menu_root.get_children() :
		tools_main_menu_root.remove_child(c);
	for c in tools_sub_menu_root.get_children() :
		tools_sub_menu_root.remove_child(c);

	#Update to current tool menus
	var main_tool_menu : Control = ToolsDatabase.get_tool_main_menu(tool_name);
	if main_tool_menu != null :
		tools_main_menu_root.add_child(main_tool_menu);
		tools_main_menu_root.visible = true;
	else :
		tools_main_menu_root.visible = false;

	var sub_tool_menu : Control = ToolsDatabase.get_tool_sub_menu(tool_name);
	if sub_tool_menu != null :
		tools_sub_menu_root.add_child(sub_tool_menu);
		tools_sub_menu_root.visible = true;
	else :
		tools_sub_menu_root.visible = false;

func switch_hdri() -> void :
	(get_tree().root.get_node("VRSketcher") as VRSketcher).hdri_manager.set_environement_hdri((get_tree().root.get_node("VRSketcher") as VRSketcher).hdri_manager.current_hdri_index + 1);

func switch_global_material() -> void :
	MaterialLibrary.switch_material();
