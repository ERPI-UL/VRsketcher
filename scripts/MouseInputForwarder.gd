extends Control

export(NodePath) var target_viewport_path : NodePath = "";
onready var target_viewport : Viewport = get_node(target_viewport_path);

func _gui_input(event : InputEvent) -> void :
	if event is InputEventMouseMotion :
		#Map mouse position in the container to the target viewport's size
		(event as InputEventMouseMotion).position = Vector2(
			range_lerp((event as InputEventMouseMotion).position.x, 0.0, rect_size.x, 0.0, target_viewport.size.x),
			range_lerp((event as InputEventMouseMotion).position.y, 0.0, rect_size.y, 0.0, target_viewport.size.y)
		);
	target_viewport.input(event);
