extends Controller

const TOUCHPAD_DEAD_ZONE : float = 0.5;
const TOOLS_MENU_DISPLAY_DISTANCE : float = 2.0;

@onready var camera				: XRCamera3D		= get_node("XRCamera3D");
@onready var controller			: XRController3D	= get_node("XRController3D");

@onready var interface_controller : XRInterfaceController = get_node("XRController3D/XRInterfaceController");

var trackpad_vector : Vector2 = Vector2.ZERO;


var interface : XRInterface
var xr_interface_hovered : bool = false;

@onready var tools_menu : XRInterface = get_node("Tools_Menu");
var tools_menu_visible : bool = false;

var tools_menu_enabled : bool = false;

func _ready() -> void :
	initialise();

	controller.controller_id = 1;
	controller.connect("button_pressed", Callable(self, "input_pressed"));
	controller.connect("button_released", Callable(self, "input_released"));

	tools_menu.visible = false;

func _process(delta: float) -> void :
	trackpad_vector = Vector2(controller.get_joystick_axis(0), controller.get_joystick_axis(1))
	
	if controller.get_is_active() == false :
		if controller.controller_id == 1 :
			controller.controller_id = 2;
		else :
			controller.controller_id = 1;

	#Hide interface controller ray when an XR interface isn't hovered
	var previous_state : bool = interface_controller.visible;
	interface_controller.visible = (tools_menu_visible == false) || (tools_menu_visible == true && xr_interface_hovered == true);
	
	#Stop tool use if tool is used when hovering the tools menu
	if interface_controller.visible == true && previous_state == false :
		if current_tool != null :
			if current_tool.tool_in_use == true :
				current_tool.stop_tool_use();
	

# Initialize the VR session
# Params : None
# Returns : 
# - true : the VR has been initialized
# - false : otherwise
func initialise() -> bool :
	if Engine.is_editor_hint():
		print("Can't initialise while in the editor");
		return false;

	if interface :
		# we are already initialised
		return true;

	interface = XRServer.find_interface("OpenXR");
	if interface and interface.initialize():
		print("OpenXR Interface initialized");

		get_viewport().arvr = true;

		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if (false;) else DisplayServer.VSYNC_DISABLED)
		Engine.target_fps = 90;
		Engine.physics_ticks_per_second = 90;

		EventBus.emit_signal("vr_enable_color_correction", true);
		return true;
	else:
		interface = null;
		return false

# Called when a button is pressed on the VR controller
# Params :
# - button_index : index of the button that was pressed
# Returns : Nothing
func input_pressed(button_index : int) -> void :
	var input_code : int = get_input_code(button_index);

	match input_code :
		Enums.InputCode.BUTTON_MENU :
			tools_menu_visible = !tools_menu_visible;
			show_tools_menu(tools_menu_visible);
		Enums.InputCode.BUTTON_A :
			tools_menu_visible = !tools_menu_visible;
			show_tools_menu(tools_menu_visible);
		Enums.InputCode.BUTTON_B :
			pass;
		Enums.InputCode.BUTTON_GRIP :
			pass;
		Enums.InputCode.BUTTON_TRIGGER :
			if tools_menu_visible == false || (tools_menu_visible == true && xr_interface_hovered == false) :
				if current_tool != null :
					current_tool.start_tool_use();
			if (current_tool == null) || (current_tool != null && current_tool.tool_in_use == false):
				interface_controller.interface_send_mouse_button_pressed(MOUSE_BUTTON_LEFT);
		Enums.InputCode.BUTTON_STICK :
			pass;
		Enums.InputCode.STICK_BUTTON_UP :
			switch_to_shortcut(Enums.ShortcutDirection.UP);
		Enums.InputCode.STICK_BUTTON_DOWN :
			switch_to_shortcut(Enums.ShortcutDirection.DOWN);
		Enums.InputCode.STICK_BUTTON_LEFT :
			switch_to_shortcut(Enums.ShortcutDirection.LEFT);
		Enums.InputCode.STICK_BUTTON_RIGHT :
			switch_to_shortcut(Enums.ShortcutDirection.RIGHT);
		_ :
			pass;

# Called when a button is released on the VR controller
# Params :
# - button_index : index of the button that was released
# Returns : Nothing
func input_released(button_index : int) -> void :
	var input_code : int = get_input_code(button_index);
	
	match input_code :
		Enums.InputCode.BUTTON_MENU :
			pass;
		Enums.InputCode.BUTTON_A :
			pass;
		Enums.InputCode.BUTTON_B :
			pass;
		Enums.InputCode.BUTTON_GRIP :
			pass;
		Enums.InputCode.BUTTON_TRIGGER :
			if tools_menu_visible == false || (tools_menu_visible == true && xr_interface_hovered == false) :
				if current_tool != null :
					current_tool.stop_tool_use();
			if (current_tool == null) || (current_tool != null && current_tool.tool_in_use == false):
				interface_controller.interface_send_mouse_button_released(MOUSE_BUTTON_LEFT);
		Enums.InputCode.BUTTON_STICK :
			pass;
		Enums.InputCode.STICK_BUTTON_UP :
			if tools_menu_visible == false || (tools_menu_visible == true && xr_interface_hovered == false) :
				if current_tool != null :
					current_tool.stop_tool_use();
		Enums.InputCode.STICK_BUTTON_DOWN :
			pass;
		Enums.InputCode.STICK_BUTTON_LEFT :
			pass;
		Enums.InputCode.STICK_BUTTON_RIGHT :
			pass;
		_ :
			pass;

# Maps the given button index to its corresponding InputCode
# Params :
# - button_index : the button index to map
# Returns : the corresponding InputCode
func get_input_code(button_index : int) -> int :
	#For usual buttons, the button index already corresponds to the right InputCode
	#Map stick to usable inputs
	if button_index == Enums.InputCode.BUTTON_STICK :
		
		trackpad_vector = Vector2(controller.get_joystick_axis(0), controller.get_joystick_axis(1));
		
		if (trackpad_vector.x > TOUCHPAD_DEAD_ZONE) && (abs(trackpad_vector.y) < TOUCHPAD_DEAD_ZONE) :
			return Enums.InputCode.STICK_BUTTON_RIGHT;
		if (trackpad_vector.x < -TOUCHPAD_DEAD_ZONE) && (abs(trackpad_vector.y) < TOUCHPAD_DEAD_ZONE) :
			return Enums.InputCode.STICK_BUTTON_LEFT;
		if (trackpad_vector.y > TOUCHPAD_DEAD_ZONE) && (abs(trackpad_vector.x) < TOUCHPAD_DEAD_ZONE) :
			return Enums.InputCode.STICK_BUTTON_UP;
		if (trackpad_vector.y < -TOUCHPAD_DEAD_ZONE) && (abs(trackpad_vector.x) < TOUCHPAD_DEAD_ZONE) :
			return Enums.InputCode.STICK_BUTTON_DOWN;

	return button_index;

func show_tools_menu(value : bool) -> void :
	interface_controller.set_enabled(value);

	if tools_menu_enabled == false :
		return;

	tools_menu.show_interface(value);
	if value == true :
		var display_offset : Vector3 = -camera.global_transform.basis.z * TOOLS_MENU_DISPLAY_DISTANCE;
		tools_menu.global_transform = camera.global_transform;
		tools_menu.global_transform.origin += display_offset;
		tools_menu.rotation_degrees.z = 0.0;

func set_xr_interface_hovered(value : bool) -> void :
	xr_interface_hovered = value;

func enable_tools_menu() -> void :
	tools_menu_enabled = true;
	tools_menu_visible = false;
	interface_controller.set_enabled(false);
