extends Node

const DEBUG_SETTINGS_FILE_PATH : String = "debug_settings.txt";


var enable_tool_teleport						: bool	= true;
var enable_tool_pen								: bool	= true;
var enable_tool_eraser							: bool	= true;
var enable_tool_measurements					: bool	= true;
var enable_tool_material_painter				: bool	= true;
var enable_tool_grab							: bool	= true;
var enable_tool_move							: bool	= true;
var enable_tool_rotate							: bool	= true;
var enable_tool_modeler							: bool	= true;

var enable_function_hdri_switch					: bool	= true;
var enable_function_global_material_switch		: bool	= true;

var spectator_camera_01_position_x				: float	= 0.0;
var spectator_camera_01_position_y				: float	= 0.0;
var spectator_camera_01_position_z				: float	= 0.0;

var spectator_camera_01_rotation_x				: float	= 0.0;
var spectator_camera_01_rotation_y				: float	= 0.0;
var spectator_camera_01_rotation_z				: float	= 0.0;

var spectator_camera_02_position_x				: float	= 0.0;
var spectator_camera_02_position_y				: float	= 0.0;
var spectator_camera_02_position_z				: float	= 0.0;

var spectator_camera_02_rotation_x				: float	= 0.0;
var spectator_camera_02_rotation_y				: float	= 0.0;
var spectator_camera_02_rotation_z				: float	= 0.0;

var screenshot_prefix							: String = "";

func _ready():
	var file : File = File.new();
	if file.file_exists(DEBUG_SETTINGS_FILE_PATH) == false :
		save_debug_settings();
	else :
		load_debug_settings();

func load_debug_settings() -> void :
	print("load debug settings");
	
	var debug_settings_file : File = File.new();
	if debug_settings_file.file_exists(DEBUG_SETTINGS_FILE_PATH) == true :
		if debug_settings_file.open(DEBUG_SETTINGS_FILE_PATH, File.READ) == OK :
			var parse_result : JSONParseResult = JSON.parse(debug_settings_file.get_as_text());
			if parse_result.error == OK :
				var settings : Dictionary = parse_result.result;
				if settings.has("enable_tool_teleport") == true :
					enable_tool_teleport = settings["enable_tool_teleport"] as bool;
				if settings.has("enable_tool_pen") == true :
					enable_tool_pen = settings["enable_tool_pen"] as bool;
				if settings.has("enable_tool_eraser") == true :
					enable_tool_eraser = settings["enable_tool_eraser"] as bool;
				if settings.has("enable_tool_measurements") == true :
					enable_tool_measurements = settings["enable_tool_measurements"] as bool;
				if settings.has("enable_tool_material_painter") == true :
					enable_tool_material_painter = settings["enable_tool_material_painter"] as bool;
				if settings.has("enable_tool_grab") == true :
					enable_tool_grab = settings["enable_tool_grab"] as bool;
				if settings.has("enable_tool_move") == true :
					enable_tool_move = settings["enable_tool_move"] as bool;
				if settings.has("enable_tool_rotate") == true :
					enable_tool_rotate = settings["enable_tool_rotate"] as bool;
				if settings.has("enable_tool_modeler") == true :
					enable_tool_modeler = settings["enable_tool_modeler"] as bool;

				if settings.has("enable_function_hdri_switch") == true :
					enable_function_hdri_switch = settings["enable_function_hdri_switch"] as bool;
				if settings.has("enable_function_global_material_switch") == true :
					enable_function_global_material_switch = settings["enable_function_global_material_switch"] as bool;

				if settings.has("spectator_camera_01_position_x") == true :
					spectator_camera_01_position_x = settings["spectator_camera_01_position_x"] as float;
				if settings.has("spectator_camera_01_position_y") == true :
					spectator_camera_01_position_y = settings["spectator_camera_01_position_y"] as float;
				if settings.has("spectator_camera_01_position_z") == true :
					spectator_camera_01_position_z = settings["spectator_camera_01_position_z"] as float;

				if settings.has("spectator_camera_01_rotation_x") == true :
					spectator_camera_01_rotation_x = settings["spectator_camera_01_rotation_x"] as float;
				if settings.has("spectator_camera_01_rotation_y") == true :
					spectator_camera_01_rotation_y = settings["spectator_camera_01_rotation_y"] as float;
				if settings.has("spectator_camera_01_rotation_z") == true :
					spectator_camera_01_rotation_z = settings["spectator_camera_01_rotation_z"] as float;

				if settings.has("spectator_camera_02_position_x") == true :
					spectator_camera_02_position_x = settings["spectator_camera_02_position_x"] as float;
				if settings.has("spectator_camera_02_position_y") == true :
					spectator_camera_02_position_y = settings["spectator_camera_02_position_y"] as float;
				if settings.has("spectator_camera_02_position_z") == true :
					spectator_camera_02_position_z = settings["spectator_camera_02_position_z"] as float;

				if settings.has("spectator_camera_02_rotation_x") == true :
					spectator_camera_02_rotation_x = settings["spectator_camera_02_rotation_x"] as float;
				if settings.has("spectator_camera_02_rotation_y") == true :
					spectator_camera_02_rotation_y = settings["spectator_camera_02_rotation_y"] as float;
				if settings.has("spectator_camera_02_rotation_z") == true :
					spectator_camera_02_rotation_z = settings["spectator_camera_02_rotation_z"] as float;

			debug_settings_file.close();

func save_debug_settings() -> void :
	var debug_settings_file : File = File.new();

	debug_settings_file.open(DEBUG_SETTINGS_FILE_PATH, File.WRITE);

	var settings : Dictionary = {
		"enable_tool_teleport"						: enable_tool_teleport,
		"enable_tool_pen"							: enable_tool_pen,
		"enable_tool_eraser"						: enable_tool_eraser,
		"enable_tool_measurements"					: enable_tool_measurements,
		"enable_tool_material_painter"				: enable_tool_material_painter,
		"enable_tool_grab"							: enable_tool_grab,
		"enable_tool_move"							: enable_tool_move,
		"enable_tool_rotate"						: enable_tool_rotate,
		"enable_tool_modeler"						: enable_tool_modeler,

		"enable_function_hdri_switch"				: enable_function_hdri_switch,
		"enable_function_global_material_switch"	: enable_function_global_material_switch,

		"spectator_camera_01_position_x"			: spectator_camera_01_position_x,
		"spectator_camera_01_position_y"			: spectator_camera_01_position_y,
		"spectator_camera_01_position_z"			: spectator_camera_01_position_z,

		"spectator_camera_01_rotation_x"			: spectator_camera_01_rotation_x,
		"spectator_camera_01_rotation_y"			: spectator_camera_01_rotation_y,
		"spectator_camera_01_rotation_z"			: spectator_camera_01_rotation_z,

		"spectator_camera_02_position_x"			: spectator_camera_02_position_x,
		"spectator_camera_02_position_y"			: spectator_camera_02_position_y,
		"spectator_camera_02_position_z"			: spectator_camera_02_position_z,

		"spectator_camera_02_rotation_x"			: spectator_camera_02_rotation_x,
		"spectator_camera_02_rotation_y"			: spectator_camera_02_rotation_y,
		"spectator_camera_02_rotation_z"			: spectator_camera_02_rotation_z
	};
	
	debug_settings_file.store_string(to_json(settings));
	debug_settings_file.close();
