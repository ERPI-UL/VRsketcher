extends Node

signal splash_closed();

func _ready() -> void :
	await get_tree().idle_frame;

	if (DebugSettings.get("disable_welcome_splash") as bool) == true :
		close_welcome_splash();


func close_welcome_splash() -> void :
	if (get_parent().get_parent() is XRInterface) == true :
		get_parent().get_parent().queue_free();
	else :
		queue_free();
	emit_signal("splash_closed");
