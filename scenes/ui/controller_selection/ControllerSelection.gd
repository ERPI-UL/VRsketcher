extends Control

func _ready() -> void :
	visible = true;

func enable_desktop_mode() -> void :
	(get_parent().get_parent() as VRSketcher).set_controller(load("res://scenes/controllers/DesktopController.tscn").instantiate(), false);
	queue_free();
	
func enable_vr_mode() -> void :
	(get_parent().get_parent() as VRSketcher).set_controller(load("res://scenes/controllers/VRController.tscn").instantiate(), true);
	queue_free();
