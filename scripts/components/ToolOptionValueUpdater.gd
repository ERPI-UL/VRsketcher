extends Node

export(String) var tool_property : String = ""

func set_value(value) -> void :
	EventBus.emit_signal("tool_set_property", tool_property, value);
