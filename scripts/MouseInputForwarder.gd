extends Control

export(NodePath) var target_viewport_path : NodePath = "";
onready var target_viewport : Viewport = get_node(target_viewport_path);

func _gui_input(event : InputEvent) -> void :
	print(event)
	target_viewport.input(event);
