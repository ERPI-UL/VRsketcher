extends Controller

const TOUCHPAD_DEAD_ZONE : float = 0.5;

const BUTTON_B = 1
const BUTTON_A = 7
const BUTTON_GRIP = 2
const BUTTON_STICK = 14
const BUTTON_TRIGGER = 15

const AXIS_X = 0
const AXIS_Y = 1
const AXIS_TRIGGER = 2
const AXIS_GRIP = 4

onready var controller : ARVRController = get_node("ARVRController");
onready var teleport_tool : Teleport = get_node("ARVRController/Teleport");

var trackpad_vector : Vector2 = Vector2.ZERO;

func _ready() -> void :
	var VR = ARVRServer.find_interface("OpenVR");

	if VR and VR.initialize():
		get_viewport().arvr = true;
		#get_viewport().hdr = true;
		#get_viewport().keep_3d_linear = true
		OS.vsync_enabled = false;
		Engine.target_fps = 90;

	controller.connect("button_pressed", self, "input_pressed")
	controller.connect("button_release", self, "input_released")

func _process(delta: float) -> void :
	trackpad_vector = Vector2(controller.get_joystick_axis(0), controller.get_joystick_axis(1))

func input_pressed(button_index : int) -> void :
	if button_index == BUTTON_TRIGGER :
		get_current_tool().start_tool_use();

	if button_index == BUTTON_STICK :
		trackpad_vector = Vector2(controller.get_joystick_axis(0), controller.get_joystick_axis(1))
		
		if trackpad_vector.length() < TOUCHPAD_DEAD_ZONE :
			teleport_tool.start_tool_use();
		else :
			if (trackpad_vector.x > TOUCHPAD_DEAD_ZONE) && (abs(trackpad_vector.y) < TOUCHPAD_DEAD_ZONE) :
				switch_tool();
			elif (trackpad_vector.x < -TOUCHPAD_DEAD_ZONE) && (abs(trackpad_vector.y) < TOUCHPAD_DEAD_ZONE) :
				switch_tool(true);
			elif (trackpad_vector.y > TOUCHPAD_DEAD_ZONE) && (abs(trackpad_vector.x) < TOUCHPAD_DEAD_ZONE) :
				get_current_tool().switch_tool_mode();
			elif (trackpad_vector.y < -TOUCHPAD_DEAD_ZONE) && (abs(trackpad_vector.x) < TOUCHPAD_DEAD_ZONE) :
				MaterialLibrary.switch_material();
	
func input_released(button_index : int) -> void :
	if button_index == BUTTON_TRIGGER :
		get_current_tool().stop_tool_use();
	
	if button_index == BUTTON_STICK :
		if teleport_tool.tool_in_use == true :
			teleport_tool.stop_tool_use();
