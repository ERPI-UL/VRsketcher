extends Control

export(NodePath) var target_viewport_path : NodePath = "";
onready var target_viewport : Viewport = get_node(target_viewport_path);

func _gui_input(event : InputEvent) -> void :
	if event is InputEventMouse :
		#Map mouse position in the container to the target viewport's size
		(event as InputEventMouse).position = Vector2(
			range_lerp((event as InputEventMouse).position.x, 0.0, rect_size.x, 0.0, target_viewport.size.x),
			range_lerp((event as InputEventMouse).position.y, 0.0, rect_size.y, 0.0, target_viewport.size.y)
		);
	target_viewport.input(event);

func _ready() -> void :
	if connect("mouse_entered", self, "update_mouse_presence", [true]) != OK :
		print("Can't connect signal mouse_entered");
	if connect("mouse_exited", self, "update_mouse_presence", [false]) != OK :
		print("Can't connect signal mouse_exited");
	
	if EventBus.connect("vr_enable_color_correction", self, "enable_vr_color_correction") != OK :
		print("Can't connect EventBus signal vr_enable_color_correction");

func update_mouse_presence(value : bool) -> void :
	KeyboardInputState.enabled = value;

func enable_vr_color_correction(value : bool) -> void :
	var m : ShaderMaterial = null;
	if value == true :
		m = ShaderMaterial.new();
		m.shader = load("res://shaders/vr_color_correction.tres");
		material = m;
