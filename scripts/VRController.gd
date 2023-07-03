extends Controller

enum InputCode{
	BUTTON_MENU			= 3,
	BUTTON_B			= 1,
	BUTTON_A			= 7,
	BUTTON_GRIP			= 2,
	BUTTON_STICK		= 14,
	BUTTON_TRIGGER		= 15,

	STICK_BUTTON_UP		= 141,
	STICK_BUTTON_DOWN	= 142,
	STICK_BUTTON_LEFT	= 143,
	STICK_BUTTON_RIGHT	= 144,
}

enum AxisCode{
	AXIS_X				= 0,
	AXIS_Y				= 1,
	AXIS_TRIGGER		= 2,
	AXIS_GRIP			= 4,
}

const TOUCHPAD_DEAD_ZONE : float = 0.5;
const TOOLS_MENU_DISPLAY_DISTANCE : float = 2.0;

onready var camera				: ARVRCamera		= get_node("ARVRCamera");
onready var controller			: ARVRController	= get_node("ARVRController");
onready var teleport_tool		: Teleport			= get_node("ARVRController/Teleport");

onready var interface_controller : XRInterfaceController = get_node("ARVRController/XRInterfaceController");

var trackpad_vector : Vector2 = Vector2.ZERO;


var interface : ARVRInterface

onready var tools_menu : XRInterface = get_node("Tools_Menu");
var tools_menu_visible : bool = false;

func _ready() -> void :
	initialise();

	controller.controller_id = 1;
	controller.connect("button_pressed", self, "input_pressed");
	controller.connect("button_release", self, "input_released");

func _process(delta: float) -> void :
	trackpad_vector = Vector2(controller.get_joystick_axis(0), controller.get_joystick_axis(1))
	
	if controller.get_is_active() == false :
		if controller.controller_id == 1 :
			controller.controller_id = 2;
		else :
			controller.controller_id = 1;

# Initialize the VR session
# Params : None
# Returns : 
# - true : the VR has been initialized
# - false : otherwise
func initialise() -> bool :
	if Engine.editor_hint:
		print("Can't initialise while in the editor");
		return false;

	if interface :
		# we are already initialised
		return true;

	interface = ARVRServer.find_interface("OpenXR");
	if interface and interface.initialize():
		print("OpenXR Interface initialized");

		get_viewport().arvr = true;

		OS.vsync_enabled = false;
		Engine.target_fps = 90;
		Engine.iterations_per_second = 90;

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
		InputCode.BUTTON_MENU :
			tools_menu_visible = !tools_menu_visible;
			show_tools_menu(tools_menu_visible);
		InputCode.BUTTON_A :
			tools_menu_visible = !tools_menu_visible;
			show_tools_menu(tools_menu_visible);
		InputCode.BUTTON_B :
			pass;
		InputCode.BUTTON_GRIP :
			pass;
		InputCode.BUTTON_TRIGGER :
			if tools_menu_visible == false :
				get_current_tool().start_tool_use();
			interface_controller.interface_send_mouse_button_pressed(BUTTON_LEFT);
		InputCode.BUTTON_STICK :
			pass;
		InputCode.STICK_BUTTON_UP :
			if tools_menu_visible == false :
				teleport_tool.start_tool_use();
		InputCode.STICK_BUTTON_DOWN :
			pass;
		InputCode.STICK_BUTTON_LEFT :
			if tools_menu_visible == false :
				get_current_tool().switch_tool_mode(true);
		InputCode.STICK_BUTTON_RIGHT :
			if tools_menu_visible == false :
				get_current_tool().switch_tool_mode();
		_ :
			pass;

# Called when a button is released on the VR controller
# Params :
# - button_index : index of the button that was released
# Returns : Nothing
func input_released(button_index : int) -> void :
	var input_code : int = get_input_code(button_index);
	
	match input_code :
		InputCode.BUTTON_MENU :
			pass;
		InputCode.BUTTON_A :
			pass;
		InputCode.BUTTON_B :
			pass;
		InputCode.BUTTON_GRIP :
			pass;
		InputCode.BUTTON_TRIGGER :
			if tools_menu_visible == false :
				get_current_tool().stop_tool_use();
			interface_controller.interface_send_mouse_button_released(BUTTON_LEFT);
		InputCode.BUTTON_STICK :
			pass;
		InputCode.STICK_BUTTON_UP :
			if tools_menu_visible == false :
				teleport_tool.stop_tool_use();
		InputCode.STICK_BUTTON_DOWN :
			pass;
		InputCode.STICK_BUTTON_LEFT :
			pass;
		InputCode.STICK_BUTTON_RIGHT :
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
	if button_index == InputCode.BUTTON_STICK :
		
		trackpad_vector = Vector2(controller.get_joystick_axis(0), controller.get_joystick_axis(1));
		
		if (trackpad_vector.x > TOUCHPAD_DEAD_ZONE) && (abs(trackpad_vector.y) < TOUCHPAD_DEAD_ZONE) :
			return InputCode.STICK_BUTTON_RIGHT;
		if (trackpad_vector.x < -TOUCHPAD_DEAD_ZONE) && (abs(trackpad_vector.y) < TOUCHPAD_DEAD_ZONE) :
			return InputCode.STICK_BUTTON_LEFT;
		if (trackpad_vector.y > TOUCHPAD_DEAD_ZONE) && (abs(trackpad_vector.x) < TOUCHPAD_DEAD_ZONE) :
			return InputCode.STICK_BUTTON_UP;
		if (trackpad_vector.y < -TOUCHPAD_DEAD_ZONE) && (abs(trackpad_vector.x) < TOUCHPAD_DEAD_ZONE) :
			return InputCode.STICK_BUTTON_DOWN;

	return button_index;

func show_tools_menu(value : bool) -> void :
	tools_menu.show_interface(value);
	
	interface_controller.set_enabled(value);
	
	if value == true :
		var display_offset : Vector3 = -camera.global_transform.basis.z * TOOLS_MENU_DISPLAY_DISTANCE;
		tools_menu.global_transform = camera.global_transform;
		tools_menu.global_transform.origin += display_offset;
		tools_menu.rotation_degrees.z = 0.0;
