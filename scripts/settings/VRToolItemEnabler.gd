extends Node

@export var linked_debug_settings: String = "";

func _ready() :
	var item : Control = get_parent();
	
	if linked_debug_settings != "" :
		var setting : bool = DebugSettings.get(linked_debug_settings) as bool;
		if setting == false :
			item.visible = false;
