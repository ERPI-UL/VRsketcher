extends Node

var project_item_template : PackedScene = load("res://scenes/ui_components/ProjectItem.tscn");

onready var import_project_dialog : FileDialog = get_node("Import_Project_Dialog");

onready var recent_projects_list : Control = get_node("Main_Panel/VBoxContainer/HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer");


onready var create_project_dialog : CreateProjectDialog = get_node("CreateProjectDialog");

func _ready():
	Project.connect("recent_projects_list_updated", self, "load_recent_projects_list");
	load_recent_projects_list();
	
func load_recent_projects_list() -> void :
	for child in recent_projects_list.get_children() :
		child.queue_free();
	
	for i in range(0, Project.application_data["recent_projects"].size()) :
		var item : ProjectItem = project_item_template.instance();
		recent_projects_list.add_child(item);
		
		var project : Dictionary = Project.application_data["recent_projects"][i];
		
		item.project_name.text = (project["project_path"] as String).rsplit("/", true, 1)[1];
		item.project_path.text = (project["project_path"] as String).rsplit("/", true, 1)[0];
		item.project_index = i;

func open_project_creation() -> void :
	create_project_dialog.popup_centered();

func open_import_project_dialog() -> void :
	import_project_dialog.popup_centered();
	
func import_project_dialog(path: String) -> void :
	pass;
