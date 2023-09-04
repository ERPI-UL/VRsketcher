extends Node

func _ready():
	(get_node("PanelContainer/ScrollContainer/VBoxContainer/Teleport") as CheckButton).pressed = DebugSettings.enable_tool_teleport;
	(get_node("PanelContainer/ScrollContainer/VBoxContainer/Pen") as CheckButton).pressed = DebugSettings.enable_tool_pen;
	(get_node("PanelContainer/ScrollContainer/VBoxContainer/Eraser") as CheckButton).pressed = DebugSettings.enable_tool_eraser;
	(get_node("PanelContainer/ScrollContainer/VBoxContainer/Measurements") as CheckButton).pressed = DebugSettings.enable_tool_measurements;
	(get_node("PanelContainer/ScrollContainer/VBoxContainer/Material_Painter") as CheckButton).pressed = DebugSettings.enable_tool_material_painter;
	(get_node("PanelContainer/ScrollContainer/VBoxContainer/Grab") as CheckButton).pressed = DebugSettings.enable_tool_grab;
	(get_node("PanelContainer/ScrollContainer/VBoxContainer/Move") as CheckButton).pressed = DebugSettings.enable_tool_move;
	(get_node("PanelContainer/ScrollContainer/VBoxContainer/Rotate") as CheckButton).pressed = DebugSettings.enable_tool_rotate;
	(get_node("PanelContainer/ScrollContainer/VBoxContainer/Modeler") as CheckButton).pressed = DebugSettings.enable_tool_modeler;
	
	
	(get_node("PanelContainer/ScrollContainer/VBoxContainer/HDRI_Switch") as CheckButton).pressed = DebugSettings.enable_function_hdri_switch;
	(get_node("PanelContainer/ScrollContainer/VBoxContainer/Global_Material_Switch") as CheckButton).pressed = DebugSettings.enable_function_global_material_switch;
	
	
	(get_node("PanelContainer2/ScrollContainer/VBoxContainer/Transform_Camera_01") as ModelTransform).set_model_transform(
		Vector3(
			DebugSettings.spectator_camera_01_position_x,
			DebugSettings.spectator_camera_01_position_y,
			DebugSettings.spectator_camera_01_position_z
		),
		Vector3(
			DebugSettings.spectator_camera_01_rotation_x,
			DebugSettings.spectator_camera_01_rotation_y,
			DebugSettings.spectator_camera_01_rotation_z
		),
		1.0
	)
		
	(get_node("PanelContainer2/ScrollContainer/VBoxContainer/Transform_Camera_02") as ModelTransform).set_model_transform(
		Vector3(
			DebugSettings.spectator_camera_02_position_x,
			DebugSettings.spectator_camera_02_position_y,
			DebugSettings.spectator_camera_02_position_z
		),
		Vector3(
			DebugSettings.spectator_camera_02_rotation_x,
			DebugSettings.spectator_camera_02_rotation_y,
			DebugSettings.spectator_camera_02_rotation_z
		),
		1.0
	)
	

func save_debug_settings() -> void :
	DebugSettings.enable_tool_teleport = (get_node("PanelContainer/ScrollContainer/VBoxContainer/Teleport") as CheckButton).pressed;
	DebugSettings.enable_tool_pen = (get_node("PanelContainer/ScrollContainer/VBoxContainer/Pen") as CheckButton).pressed;
	DebugSettings.enable_tool_eraser = (get_node("PanelContainer/ScrollContainer/VBoxContainer/Eraser") as CheckButton).pressed;
	DebugSettings.enable_tool_measurements = (get_node("PanelContainer/ScrollContainer/VBoxContainer/Measurements") as CheckButton).pressed;
	DebugSettings.enable_tool_material_painter = (get_node("PanelContainer/ScrollContainer/VBoxContainer/Material_Painter") as CheckButton).pressed;
	DebugSettings.enable_tool_grab = (get_node("PanelContainer/ScrollContainer/VBoxContainer/Grab") as CheckButton).pressed;
	DebugSettings.enable_tool_move = (get_node("PanelContainer/ScrollContainer/VBoxContainer/Move") as CheckButton).pressed;
	DebugSettings.enable_tool_rotate = (get_node("PanelContainer/ScrollContainer/VBoxContainer/Rotate") as CheckButton).pressed;
	DebugSettings.enable_tool_modeler = (get_node("PanelContainer/ScrollContainer/VBoxContainer/Modeler") as CheckButton).pressed;

	DebugSettings.enable_function_hdri_switch = (get_node("PanelContainer/ScrollContainer/VBoxContainer/HDRI_Switch") as CheckButton).pressed;
	DebugSettings.enable_function_global_material_switch = (get_node("PanelContainer/ScrollContainer/VBoxContainer/Global_Material_Switch") as CheckButton).pressed;

	var spectator_camera_01 : SpectatorCamera = get_tree().root.get_node("VRSketcher").get_node("Spectator_Cameras/SpectatorCamera_01") as SpectatorCamera;
	var spectator_camera_02 : SpectatorCamera = get_tree().root.get_node("VRSketcher").get_node("Spectator_Cameras/SpectatorCamera_02") as SpectatorCamera;

	DebugSettings.spectator_camera_01_position_x = spectator_camera_01.camera.global_transform.origin.x;
	DebugSettings.spectator_camera_01_position_y = spectator_camera_01.camera.global_transform.origin.y;
	DebugSettings.spectator_camera_01_position_z = spectator_camera_01.camera.global_transform.origin.z;

	DebugSettings.spectator_camera_01_rotation_x = spectator_camera_01.camera.rotation_degrees.x;
	DebugSettings.spectator_camera_01_rotation_y = spectator_camera_01.camera.rotation_degrees.y;
	DebugSettings.spectator_camera_01_rotation_z = spectator_camera_01.camera.rotation_degrees.z;

	DebugSettings.spectator_camera_02_position_x = spectator_camera_02.camera.global_transform.origin.x;
	DebugSettings.spectator_camera_02_position_y = spectator_camera_02.camera.global_transform.origin.y;
	DebugSettings.spectator_camera_02_position_z = spectator_camera_02.camera.global_transform.origin.z;

	DebugSettings.spectator_camera_02_rotation_x = spectator_camera_02.camera.rotation_degrees.x;
	DebugSettings.spectator_camera_02_rotation_y = spectator_camera_02.camera.rotation_degrees.y;
	DebugSettings.spectator_camera_02_rotation_z = spectator_camera_02.camera.rotation_degrees.z;

	DebugSettings.save_debug_settings();
	
func set_screenshot_prefix(value : String) -> void :
	DebugSettings.screenshot_prefix = value;
