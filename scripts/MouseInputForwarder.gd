extends Control

@export var target_viewport_path: NodePath = "";
@onready var target_viewport : SubViewport = get_node(target_viewport_path);

func _gui_input(event : InputEvent) -> void :
	if event is InputEventMouse :
		#Map mouse position in the container to the target viewport's size
		(event as InputEventMouse).position = Vector2(
			remap((event as InputEventMouse).position.x, 0.0, size.x, 0.0, target_viewport.size.x),
			remap((event as InputEventMouse).position.y, 0.0, size.y, 0.0, target_viewport.size.y)
		);
	target_viewport.input(event);

func _ready() -> void :
	connect("mouse_entered", Callable(self, "update_mouse_presence").bind(true));
	connect("mouse_exited", Callable(self, "update_mouse_presence").bind(false));

func update_mouse_presence(value : bool) -> void :
	KeyboardInputState.enabled = value;
