extends Control

func _ready() -> void :
	call_deferred("reparent_to_file_dialog");


func reparent_to_file_dialog() -> void :
	var dialog : FileDialog = get_parent();
	
	if dialog is FileDialog :
		dialog.remove_child(self);
		dialog.get_child(3).add_child(self);
