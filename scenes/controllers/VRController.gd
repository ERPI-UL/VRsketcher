extends Controller

const TOUCHPAD_DEAD_ZONE : float = 0.5;

onready var camera				: ARVRCamera		= get_node("ARVRCamera");
onready var controller			: ARVRController	= get_node("ARVRController_Right");

onready var interface_controller : XRInterfaceController = get_node("ARVRController_Right/XRInterfaceController");

var trackpad_vector : Vector2 = Vector2.ZERO;


var interface : ARVRInterface
var xr_interface_hovered : bool = false;

onready var xr_palette : XRInterface = get_node("ARVRController_Left/XRInterface");

export(float, 0.0, 1.0, 0.05) var xr_palette_visibility_angle : float = 0.5;

func _ready() -> void :
	initialise();

	if controller.connect("button_pressed", self, "input_pressed") != OK :
		print("Can't connect ARVRController signal button_pressed");
	if controller.connect("button_release", self, "input_released") != OK :
		print("Can't connect ARVRController signal button_release");

func _process(_delta: float) -> void :
	trackpad_vector = Vector2(controller.get_joystick_axis(0), controller.get_joystick_axis(1))

	#Hide interface controller ray when an XR interface isn't hovered
	if current_tool == null :
		interface_controller.visible = interface_controller.enabled == true;
	else :
		interface_controller.visible = interface_controller.enabled == true && current_tool.tool_in_use == false;
	
	#Stop tool use if tool is used when hovering the tools menu
	if interface_controller.hover_state == true && interface_controller.previous_hover_state == false :
		if current_tool != null :
			if current_tool.tool_in_use == true :
				current_tool.stop_tool_use();
				if current_tool.interacted_object != null :
					if current_tool.interacted_object is Model3D == true :
						(current_tool.interacted_object as Model3D).set_overlay_material(null);
	
	xr_palette.visible = camera.global_transform.basis.z.dot(xr_palette.global_transform.basis.z) >= xr_palette_visibility_angle;


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
			show_tools_menu(!interface_controller.enabled);
		Enums.InputCode.BUTTON_A :
			show_tools_menu(!interface_controller.enabled);
		Enums.InputCode.BUTTON_B :
			OS.show_virtual_keyboard()
		Enums.InputCode.BUTTON_GRIP :
			pass;
		Enums.InputCode.BUTTON_TRIGGER :
			if interface_controller.enabled == false || (interface_controller.enabled == true && xr_interface_hovered == false) :
				if current_tool != null :
					show_tools_menu(false);
					current_tool.start_tool_use();
			if (current_tool == null) || (current_tool != null && current_tool.tool_in_use == false):
				interface_controller.interface_send_mouse_button_pressed(BUTTON_LEFT);
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
			if interface_controller.enabled == false || xr_interface_hovered == false :
				if current_tool != null :
					current_tool.stop_tool_use();
			if (current_tool == null) || (current_tool != null && current_tool.tool_in_use == false):
				interface_controller.interface_send_mouse_button_released(BUTTON_LEFT);
		Enums.InputCode.BUTTON_STICK :
			pass;
		Enums.InputCode.STICK_BUTTON_UP :
			if interface_controller.enabled == false || xr_interface_hovered == false :
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

func set_xr_interface_hovered(value : bool) -> void :
	xr_interface_hovered = value;

func enable_tools_menu() -> void :
	interface_controller.set_enabled(false);
