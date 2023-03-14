extends Control
class_name ModelItem

var target_model : Model3D = null;
var target_model_manager : ModelsManager = null;

onready var btn_fold : CheckButton = get_node("VBoxContainer/HBoxContainer/Fold");

onready var model_name : Label = get_node("VBoxContainer/HBoxContainer/Model_Name");
onready var model_transform : ModelTransform = get_node("VBoxContainer/ModelTransform");


signal model_position_changed(value);
signal model_rotation_changed(value);
signal model_scale_changed(value);

func set_target_model(model : Model3D) -> void :
	target_model = model;
	model_name.text = model.inspector_name;
	
	model_transform.set_model_transform(model.global_transform.origin, model.rotation_degrees, model.scale.x);

func fold_item(override : bool = false, value : bool = true) -> void :
	if override == true :
		target_model.inspector_unfolded = value;
		model_transform.visible = value;
		btn_fold.pressed = value;
	else :
		target_model.inspector_unfolded = btn_fold.pressed;
		model_transform.visible = target_model.inspector_unfolded;

func delete_model() -> void :
	target_model_manager.remove_model(target_model);

func set_model_position(value : Vector3) -> void :
	target_model.global_transform.origin = value;

func set_model_rotation(value : Vector3) -> void :
	target_model.rotation_degrees = value;

func set_model_scale(value : float) -> void :
	target_model.scale = Vector3.ONE * value;
