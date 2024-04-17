extends Control

onready var drawn_models : ModelItemManager = get_node("Panel/MarginContainer/TabContainer/Drawn/ModelItemManager_Drawn");
onready var imported_models : ModelItemManager = get_node("Panel/MarginContainer/TabContainer/Imported/ModelItemManager_Imported");
onready var notes : NoteItemManager = get_node("Panel/MarginContainer/TabContainer/Notes/NoteItemManager");

func _ready() -> void :
	if EventBus.connect("scene_drawn_models_list_updated", drawn_models, "refresh_model_list") != OK :
		print("Can't connect EventBus signal scene_drawn_models_list_updated");

	if EventBus.connect("scene_imported_models_list_updated", imported_models, "refresh_model_list") != OK :
		print("Can't connect EventBus signal scene_imported_models_list_updated");

	if EventBus.connect("scene_notes_list_updated", notes, "refresh_notes_list") != OK :
		print("Can't connect EventBus signal scene_notes_list_updated");
