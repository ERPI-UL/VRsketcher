extends WindowDialog
class_name CreateProjectDialog

export(NodePath) var file_system_dialog_path : NodePath = "";
onready var file_system_dialog : FileDialog = get_node(file_system_dialog_path);

onready var project_name : LineEdit = get_node("PanelContainer/VBoxContainer/GridContainer/Project_Name");
onready var project_path : LineEdit = get_node("PanelContainer/VBoxContainer/GridContainer/HBoxContainer/Project_Path");

func _ready() -> void:
	if file_system_dialog.connect("dir_selected", self, "selected_directory_changed") != OK :
		pass;

func open_file_system_dialog() -> void :
	file_system_dialog.popup_centered();
	file_system_dialog.current_dir = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS);

func selected_directory_changed(path : String) -> void :
	project_path.text = path;

func confirm_project_creation() -> void :
	Project.new_project(project_name.text, project_path.text);
	hide();
	
func cancel_project_creation() -> void :
	hide();

func open_file_dialog() -> void :
	file_system_dialog.popup_centered();
	file_system_dialog.current_dir = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS);
