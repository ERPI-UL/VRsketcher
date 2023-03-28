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

onready var controller			: ARVRController	= get_node("ARVRController");
onready var teleport_tool		: Teleport			= get_node("ARVRController/Teleport");
onready var tool_selection_tool	: ToolsSelection	= get_node("ARVRController/ToolsSelection");

var trackpad_vector : Vector2 = Vector2.ZERO;


var interface : ARVRInterface

func _ready() -> void :
	initialise();

	controller.controller_id = 1;
	controller.connect("button_pressed", self, "input_pressed");
	controller.connect("button_release", self, "input_released");

func initialise() -> bool:
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

		emit_signal("initialised");
		return true;
	else:
		interface = null;

		emit_signal("failed_initialisation");
		return false


func _process(delta: float) -> void :
	trackpad_vector = Vector2(controller.get_joystick_axis(0), controller.get_joystick_axis(1))
	
	if controller.get_is_active() == false :
		if controller.controller_id == 1 :
			controller.controller_id = 2;
		else :
			controller.controller_id = 1;

func input_pressed(button_index : int) -> void :
	var input_code : int = get_input_code(button_index);

	match input_code :
		InputCode.BUTTON_MENU :
			MaterialLibrary.switch_material();

		InputCode.BUTTON_A :
			MaterialLibrary.switch_material();

		InputCode.BUTTON_B :
			pass;

		InputCode.BUTTON_GRIP :
			pass;

		InputCode.BUTTON_TRIGGER :
			get_current_tool().start_tool_use();

		InputCode.BUTTON_STICK :
			tool_selection_tool.start_tool_use();

		InputCode.STICK_BUTTON_UP :
			teleport_tool.start_tool_use();
			
		InputCode.STICK_BUTTON_DOWN :
			get_current_tool().switch_tool_mode();
			
		InputCode.STICK_BUTTON_LEFT :
			pass;
			
		InputCode.STICK_BUTTON_RIGHT :
			pass;
		_ :
			pass;
	
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
			get_current_tool().stop_tool_use();

		InputCode.BUTTON_STICK :
			tool_selection_tool.stop_tool_use();

		InputCode.STICK_BUTTON_UP :
			teleport_tool.stop_tool_use();

		InputCode.STICK_BUTTON_DOWN :
			pass;
			
		InputCode.STICK_BUTTON_LEFT :
			pass;
			
		InputCode.STICK_BUTTON_RIGHT :
			pass;
		_ :
			pass;

func get_input_code(button_index : int) -> int :
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

