extends Node
class_name ProjectItem

@onready var project_name : Label = get_node("HBoxContainer/VBoxContainer/Name");
@onready var project_path : Label = get_node("HBoxContainer/VBoxContainer/Path3D");

var project_index : int = -1;

func load_project() -> void :
	Project.load_project(project_index);
