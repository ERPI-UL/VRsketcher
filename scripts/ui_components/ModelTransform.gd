extends Control
class_name ModelTransform

onready var scale : SpinBox = get_node("Model_Scale/Scale");

onready var position_x : SpinBox = get_node("Model_Position/VBoxContainer/HBoxContainer/Position_X");
onready var position_y : SpinBox = get_node("Model_Position/VBoxContainer/HBoxContainer2/Position_Y");
onready var position_z : SpinBox = get_node("Model_Position/VBoxContainer/HBoxContainer3/Position_Z");

onready var rotation_x : SpinBox = get_node("Model_Rotation/VBoxContainer/HBoxContainer/Rotation_X");
onready var rotation_y : SpinBox = get_node("Model_Rotation/VBoxContainer/HBoxContainer2/Rotation_Y");
onready var rotation_z : SpinBox = get_node("Model_Rotation/VBoxContainer/HBoxContainer3/Rotation_Z");

signal model_position_changed(value);
signal model_rotation_changed(value);
signal model_scale_changed(value);

func set_model_transform(model_position : Vector3, model_rotation : Vector3, model_scale : float) -> void :
	position_x.value = model_position.x;
	position_y.value = model_position.y;
	position_z.value = model_position.z;
	
	rotation_x.value = model_rotation.x;
	rotation_y.value = model_rotation.y;
	rotation_z.value = model_rotation.z;
	
	scale.value = model_scale;

func set_model_position(_value) -> void :
	emit_signal("model_position_changed", Vector3(position_x.value, position_y.value, position_z.value));

func set_model_rotation(_value) -> void :
	emit_signal("model_rotation_changed", Vector3(rotation_x.value, rotation_y.value, rotation_z.value));

func set_model_scale(_value : float) -> void :
	emit_signal("model_scale_changed", scale.value);


func update_inspector_position(value : Vector3) -> void :
	disable_signals();
	position_x.value = value.x;
	position_y.value = value.y;
	position_z.value = value.z;
	enable_signals();

func update_inspector_rotation(value : Vector3) -> void :
	disable_signals();
	rotation_x.value = value.x;
	rotation_y.value = value.y;
	rotation_z.value = value.z;
	enable_signals();

func update_inspector_scale(value : float) -> void :
	disable_signals();
	scale.value = value;
	enable_signals();

func enable_signals() -> void :
	if position_x.is_connected("value_changed", self, "set_model_position") == false :
		position_x.connect("value_changed", self, "set_model_position")
	if position_y.is_connected("value_changed", self, "set_model_position") == false :
		position_y.connect("value_changed", self, "set_model_position")
	if position_z.is_connected("value_changed", self, "set_model_position") == false :
		position_z.connect("value_changed", self, "set_model_position")

	if rotation_x.is_connected("value_changed", self, "set_model_rotation") == false :
		rotation_x.connect("value_changed", self, "set_model_rotation")
	if rotation_y.is_connected("value_changed", self, "set_model_rotation") == false :
		rotation_y.connect("value_changed", self, "set_model_rotation")
	if rotation_z.is_connected("value_changed", self, "set_model_rotation") == false :
		rotation_z.connect("value_changed", self, "set_model_rotation")
	
	if scale.is_connected("value_changed", self, "set_model_scale") == false :
		scale.connect("value_changed", self, "set_model_scale")

func disable_signals() -> void :
	if position_x.is_connected("value_changed", self, "set_model_position") == true :
		position_x.disconnect("value_changed", self, "set_model_position");
	if position_y.is_connected("value_changed", self, "set_model_position") == true :
		position_y.disconnect("value_changed", self, "set_model_position")
	if position_z.is_connected("value_changed", self, "set_model_position") == true :
		position_z.disconnect("value_changed", self, "set_model_position")

	if rotation_x.is_connected("value_changed", self, "set_model_rotation") == true :
		rotation_x.disconnect("value_changed", self, "set_model_rotation")
	if rotation_y.is_connected("value_changed", self, "set_model_rotation") == true :
		rotation_y.disconnect("value_changed", self, "set_model_rotation")
	if rotation_z.is_connected("value_changed", self, "set_model_rotation") == true :
		rotation_z.disconnect("value_changed", self, "set_model_rotation")

	if scale.is_connected("value_changed", self, "set_model_scale") == true :
		scale.disconnect("value_changed", self, "set_model_scale")
