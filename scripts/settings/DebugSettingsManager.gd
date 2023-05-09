extends Node

func _ready():
	(get_node("VBoxContainer/Pen") as CheckButton).pressed = DebugSettings.enable_tool_pen;
	(get_node("VBoxContainer/Eraser") as CheckButton).pressed = DebugSettings.enable_tool_eraser;
	(get_node("VBoxContainer/Measurements") as CheckButton).pressed = DebugSettings.enable_tool_measurements;
	(get_node("VBoxContainer/Material_Painter") as CheckButton).pressed = DebugSettings.enable_tool_material_painter;
	(get_node("VBoxContainer/Move") as CheckButton).pressed = DebugSettings.enable_tool_move;
	(get_node("VBoxContainer/Rotate") as CheckButton).pressed = DebugSettings.enable_tool_rotate;
	(get_node("VBoxContainer/Modeler") as CheckButton).pressed = DebugSettings.enable_tool_modeler;
	
	
	(get_node("VBoxContainer/HDRI_Switch") as CheckButton).pressed = DebugSettings.enable_function_hdri_switch;
	(get_node("VBoxContainer/Global_Material_Switch") as CheckButton).pressed = DebugSettings.enable_function_global_material_switch;

func save_debug_settings() -> void :
	DebugSettings.enable_tool_pen = (get_node("VBoxContainer/Pen") as CheckButton).pressed;
	DebugSettings.enable_tool_eraser = (get_node("VBoxContainer/Eraser") as CheckButton).pressed;
	DebugSettings.enable_tool_measurements = (get_node("VBoxContainer/Measurements") as CheckButton).pressed;
	DebugSettings.enable_tool_material_painter = (get_node("VBoxContainer/Material_Painter") as CheckButton).pressed;
	DebugSettings.enable_tool_move = (get_node("VBoxContainer/Move") as CheckButton).pressed;
	DebugSettings.enable_tool_rotate = (get_node("VBoxContainer/Rotate") as CheckButton).pressed;
	DebugSettings.enable_tool_modeler = (get_node("VBoxContainer/Modeler") as CheckButton).pressed;

	DebugSettings.enable_function_hdri_switch = (get_node("VBoxContainer/HDRI_Switch") as CheckButton).pressed;
	DebugSettings.enable_function_global_material_switch = (get_node("VBoxContainer/Global_Material_Switch") as CheckButton).pressed;

	DebugSettings.save_debug_settings();
