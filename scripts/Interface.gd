extends Control

@onready var render_viewport : SubViewport = get_node("../SubViewport");

func _ready() -> void :
	EventBus.connect("vr_enable_color_correction", Callable(self, "enable_vr_color_correction"));

func take_screenshot() -> void :
	#var directory : DirAccess = DirAccess.new();
	
	var path : String = OS.get_executable_path().get_base_dir() + "/screenshots";
	
	var dir = DirAccess.open(path);
	
	if dir.dir_exists(path) == false :
		dir.make_dir(path);

	var date : Dictionary = Time.get_datetime_dict_from_system();
	
	var file_name : String = "";
	if DebugSettings.screenshot_prefix != "" :
		file_name += DebugSettings.screenshot_prefix + "-";
	file_name += str(date["day"]) + "-";
	file_name += str(date["month"]) + "-";
	file_name += str(date["year"]) + "_";
	file_name += str(date["hour"] )+ "-";
	file_name += str(date["minute"]) + "-";
	file_name += str(date["second"]);
	
	file_name = path + "/" + file_name + ".png";

	var screenshot : Image = render_viewport.get_texture().get_data();
 
	screenshot.flip_y();
	screenshot.save_png(file_name);
	
	print("Saved screenshot to : " + file_name);

func enable_vr_color_correction(value : bool) -> void :
	var m : ShaderMaterial = null;
	if value == true :
		m = ShaderMaterial.new();
		m.gdshader = load("res://shaders/vr_color_correction.tres");
		(get_node("VRSketcherInterface/HBoxContainer/AspectRatioContainer/Viewport_Render") as Control).material = m;
