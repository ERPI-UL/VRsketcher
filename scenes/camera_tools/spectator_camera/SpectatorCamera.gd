extends Viewport
class_name SpectatorCamera

onready var camera : Camera = get_node("Camera");

export var preview_resolution : Vector2 = Vector2(720.0, 480.0);
export var export_resolution : Vector2 = Vector2(1920.0, 1080.0);

func _ready() -> void :
	size = preview_resolution;

func save_screenshot() -> void :
	render_target_v_flip = false;
	size = export_resolution;
	yield(get_tree(), "idle_frame");
	yield(get_tree(), "idle_frame");
	
	
	var directory : Directory = Directory.new();	
	var path : String = OS.get_executable_path().get_base_dir() + "/screenshots";
	
	if directory.dir_exists(path) == false :
		directory.make_dir(path);

	var date : Dictionary = Time.get_datetime_dict_from_system();
	
	var file_name : String = "";
	if DebugSettings.screenshot_prefix != "" :
		file_name += DebugSettings.screenshot_prefix + "-";
	file_name += name + "-";
	file_name += str(date["day"]) + "-";
	file_name += str(date["month"]) + "-";
	file_name += str(date["year"]) + "_";
	file_name += str(date["hour"] )+ "-";
	file_name += str(date["minute"]) + "-";
	file_name += str(date["second"]);
	
	file_name = path + "/" + file_name + ".png";

	var screenshot : Image = get_texture().get_data();
 
	screenshot.flip_y();
	screenshot.save_png(file_name);
	
	print("Saved screenshot to : " + file_name);
	
	
	render_target_v_flip = true;
	size = preview_resolution;
	
func set_camera_position(value : Vector3) -> void :
	camera.global_transform.origin = value;

func set_camera_rotation(value : Vector3) -> void :
	camera.rotation_degrees = value;
