extends Control

func _ready() -> void :
	connect("mouse_entered", self, "update_mouse_presence", [true]);
	connect("mouse_exited", self, "update_mouse_presence", [false]);

func update_mouse_presence(value : bool) -> void :
	KeyboardInputState.enabled = value;
