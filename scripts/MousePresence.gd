extends Control

func _ready() -> void :
	connect("mouse_entered", Callable(self, "update_mouse_presence").bind(true));
	connect("mouse_exited", Callable(self, "update_mouse_presence").bind(false));

func update_mouse_presence(value : bool) -> void :
	KeyboardInputState.enabled = value;
