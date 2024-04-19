extends FileDialog

var smooth_shading : bool = true;

func _ready() -> void :
	if connect("file_selected", self, "import_model") != OK :
		pass;

func open_import_window() -> void :
	popup_centered();
	current_dir = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS);

func import_model(path : String) -> void :
	EventBus.emit_signal("project_import_model", path, smooth_shading);

func set_smooth_shading(value : bool) -> void :
	smooth_shading = value;
