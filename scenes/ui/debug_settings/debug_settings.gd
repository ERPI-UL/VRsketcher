extends Node

export(NodePath) var spectator_camera_1_path : NodePath = "";
export(NodePath) var spectator_camera_2_path : NodePath = "";

func _ready() -> void :
	(get_node("VBoxContainer/Features/ScrollContainer/VBoxContainer/Teleport") as CheckButton).pressed = DebugSettings.enable_tool_teleport;
	(get_node("VBoxContainer/Features/ScrollContainer/VBoxContainer/Fly") as CheckButton).pressed = DebugSettings.enable_tool_fly;
	(get_node("VBoxContainer/Features/ScrollContainer/VBoxContainer/Pen") as CheckButton).pressed = DebugSettings.enable_tool_pen;
	(get_node("VBoxContainer/Features/ScrollContainer/VBoxContainer/Eraser") as CheckButton).pressed = DebugSettings.enable_tool_eraser;
	(get_node("VBoxContainer/Features/ScrollContainer/VBoxContainer/Measurements") as CheckButton).pressed = DebugSettings.enable_tool_measurements;
	(get_node("VBoxContainer/Features/ScrollContainer/VBoxContainer/Material_Painter") as CheckButton).pressed = DebugSettings.enable_tool_material_painter;
	(get_node("VBoxContainer/Features/ScrollContainer/VBoxContainer/Grab") as CheckButton).pressed = DebugSettings.enable_tool_grab;
	(get_node("VBoxContainer/Features/ScrollContainer/VBoxContainer/Move") as CheckButton).pressed = DebugSettings.enable_tool_move;
	(get_node("VBoxContainer/Features/ScrollContainer/VBoxContainer/Rotate") as CheckButton).pressed = DebugSettings.enable_tool_rotate;
	(get_node("VBoxContainer/Features/ScrollContainer/VBoxContainer/Modeler") as CheckButton).pressed = DebugSettings.enable_tool_modeler;
	(get_node("VBoxContainer/Features/ScrollContainer/VBoxContainer/Duplicate") as CheckButton).pressed = DebugSettings.enable_tool_duplicate;
	(get_node("VBoxContainer/Features/ScrollContainer/VBoxContainer/Note") as CheckButton).pressed = DebugSettings.enable_tool_note;

	(get_node("VBoxContainer/Features/ScrollContainer/VBoxContainer/HDRI_Switch") as CheckButton).pressed = DebugSettings.enable_function_hdri_switch;
	(get_node("VBoxContainer/Features/ScrollContainer/VBoxContainer/Global_Material_Switch") as CheckButton).pressed = DebugSettings.enable_function_global_material_switch;

	(get_node("VBoxContainer/Features/ScrollContainer/VBoxContainer/Disable_Welcome_Splash") as CheckButton).pressed = DebugSettings.disable_welcome_splash;


	(get_node("VBoxContainer/Spectator_Cameras/ScrollContainer/VBoxContainer/Transform_Camera_01") as ModelTransform).set_model_transform(
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
		
	(get_node("VBoxContainer/Spectator_Cameras/ScrollContainer/VBoxContainer/Transform_Camera_02") as ModelTransform).set_model_transform(
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
	
	if spectator_camera_1_path != "" :
		(get_node("VBoxContainer/Spectator_Cameras/ScrollContainer/VBoxContainer/Preview_Camera_01") as TextureRect).texture = (get_node(spectator_camera_1_path) as SpectatorCamera).get_texture();
		(get_node("VBoxContainer/Spectator_Cameras/ScrollContainer/VBoxContainer/Transform_Camera_01") as ModelTransform).connect(
			"model_position_changed", 
			(get_node(spectator_camera_1_path) as SpectatorCamera),
			"set_camera_position"
			);
		(get_node("VBoxContainer/Spectator_Cameras/ScrollContainer/VBoxContainer/Transform_Camera_01") as ModelTransform).connect(
			"model_rotation_changed", 
			(get_node(spectator_camera_1_path) as SpectatorCamera),
			"set_camera_rotation"
			);
	if spectator_camera_2_path != "" :
		(get_node("VBoxContainer/Spectator_Cameras/ScrollContainer/VBoxContainer/Preview_Camera_02") as TextureRect).texture = (get_node(spectator_camera_2_path) as SpectatorCamera).get_texture();
		(get_node("VBoxContainer/Spectator_Cameras/ScrollContainer/VBoxContainer/Transform_Camera_02") as ModelTransform).connect(
			"model_position_changed", 
			(get_node(spectator_camera_2_path) as SpectatorCamera),
			"set_camera_position"
			);
		(get_node("VBoxContainer/Spectator_Cameras/ScrollContainer/VBoxContainer/Transform_Camera_02") as ModelTransform).connect(
			"model_rotation_changed", 
			(get_node(spectator_camera_2_path) as SpectatorCamera),
			"set_camera_rotation"
			);

func save_debug_settings() -> void :
	DebugSettings.enable_tool_teleport = (get_node("VBoxContainer/Features/ScrollContainer/VBoxContainer/Teleport") as CheckButton).pressed;
	DebugSettings.enable_tool_fly = (get_node("VBoxContainer/Features/ScrollContainer/VBoxContainer/Fly") as CheckButton).pressed;
	DebugSettings.enable_tool_pen = (get_node("VBoxContainer/Features/ScrollContainer/VBoxContainer/Pen") as CheckButton).pressed;
	DebugSettings.enable_tool_eraser = (get_node("VBoxContainer/Features/ScrollContainer/VBoxContainer/Eraser") as CheckButton).pressed;
	DebugSettings.enable_tool_measurements = (get_node("VBoxContainer/Features/ScrollContainer/VBoxContainer/Measurements") as CheckButton).pressed;
	DebugSettings.enable_tool_material_painter = (get_node("VBoxContainer/Features/ScrollContainer/VBoxContainer/Material_Painter") as CheckButton).pressed;
	DebugSettings.enable_tool_grab = (get_node("VBoxContainer/Features/ScrollContainer/VBoxContainer/Grab") as CheckButton).pressed;
	DebugSettings.enable_tool_move = (get_node("VBoxContainer/Features/ScrollContainer/VBoxContainer/Move") as CheckButton).pressed;
	DebugSettings.enable_tool_rotate = (get_node("VBoxContainer/Features/ScrollContainer/VBoxContainer/Rotate") as CheckButton).pressed;
	DebugSettings.enable_tool_modeler = (get_node("VBoxContainer/Features/ScrollContainer/VBoxContainer/Modeler") as CheckButton).pressed;
	DebugSettings.enable_tool_duplicate = (get_node("VBoxContainer/Features/ScrollContainer/VBoxContainer/Duplicate") as CheckButton).pressed;
	DebugSettings.enable_tool_note = (get_node("VBoxContainer/Features/ScrollContainer/VBoxContainer/Note") as CheckButton).pressed;

	DebugSettings.enable_function_hdri_switch = (get_node("VBoxContainer/Features/ScrollContainer/VBoxContainer/HDRI_Switch") as CheckButton).pressed;
	DebugSettings.enable_function_global_material_switch = (get_node("VBoxContainer/Features/ScrollContainer/VBoxContainer/Global_Material_Switch") as CheckButton).pressed;

	DebugSettings.disable_welcome_splash = (get_node("VBoxContainer/Features/ScrollContainer/VBoxContainer/Disable_Welcome_Splash") as CheckButton).pressed;

	if spectator_camera_1_path != "" :
		var spectator_camera_01 : SpectatorCamera = get_node(spectator_camera_1_path) as SpectatorCamera;

		DebugSettings.spectator_camera_01_position_x = spectator_camera_01.camera.global_transform.origin.x;
		DebugSettings.spectator_camera_01_position_y = spectator_camera_01.camera.global_transform.origin.y;
		DebugSettings.spectator_camera_01_position_z = spectator_camera_01.camera.global_transform.origin.z;

		DebugSettings.spectator_camera_01_rotation_x = spectator_camera_01.camera.rotation_degrees.x;
		DebugSettings.spectator_camera_01_rotation_y = spectator_camera_01.camera.rotation_degrees.y;
		DebugSettings.spectator_camera_01_rotation_z = spectator_camera_01.camera.rotation_degrees.z;

	if spectator_camera_2_path != "" :
		var spectator_camera_02 : SpectatorCamera = get_node(spectator_camera_2_path) as SpectatorCamera;

		DebugSettings.spectator_camera_02_position_x = spectator_camera_02.camera.global_transform.origin.x;
		DebugSettings.spectator_camera_02_position_y = spectator_camera_02.camera.global_transform.origin.y;
		DebugSettings.spectator_camera_02_position_z = spectator_camera_02.camera.global_transform.origin.z;

		DebugSettings.spectator_camera_02_rotation_x = spectator_camera_02.camera.rotation_degrees.x;
		DebugSettings.spectator_camera_02_rotation_y = spectator_camera_02.camera.rotation_degrees.y;
		DebugSettings.spectator_camera_02_rotation_z = spectator_camera_02.camera.rotation_degrees.z;

	DebugSettings.save_debug_settings();

func set_screenshot_prefix(value : String) -> void :
	DebugSettings.screenshot_prefix = value;
