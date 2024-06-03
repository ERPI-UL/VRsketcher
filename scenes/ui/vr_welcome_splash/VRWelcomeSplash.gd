extends Node

signal splash_closed();

func _ready() -> void :
	yield(get_tree(), "idle_frame");

	if (DebugSettings.get("disable_welcome_splash") as bool) == true :
		close_welcome_splash();

	var splash : Texture = null;
	
	if ["Android"].find(OS.get_name()) >= 0 :
		splash = load("res://assets/welcome_splashes/splash_meta_quest.png");
	else :
		match DebugSettings.hmd_splash :
			0 :
				splash = load("res://assets/welcome_splashes/splash_vive_pro.png");
			1 :
				splash = load("res://assets/welcome_splashes/splash_vive_cosmos.png");
			2 :
				splash = load("res://assets/welcome_splashes/splash_meta_quest.png");
	(get_node("CenterContainer/PanelContainer/VBoxContainer/MarginContainer/TextureRect") as TextureRect).texture = splash;

func close_welcome_splash() -> void :
	if (get_parent().get_parent() is XRInterface) == true :
		get_parent().get_parent().queue_free();
	else :
		queue_free();
	emit_signal("splash_closed");
