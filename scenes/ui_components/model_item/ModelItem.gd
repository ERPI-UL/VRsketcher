extends Control
class_name ModelItem

var target_model : Model3D = null;
var target_model_manager : ModelsManager = null;

@onready var btn_fold : CheckButton = get_node("VBoxContainer/HBoxContainer/Fold");

@onready var fold_container : Control = get_node("VBoxContainer/VBoxContainer");

@onready var model_name : Label = get_node("VBoxContainer/HBoxContainer/Model_Name");
@onready var model_transform : ModelTransform = get_node("VBoxContainer/VBoxContainer/ModelTransform");
@onready var model_interactable : CheckBox = get_node("VBoxContainer/VBoxContainer/HBoxContainer2/interactable_switch");
@onready var model_override_material : OptionButton = get_node("VBoxContainer/VBoxContainer/HBoxContainer/material_override");


signal model_position_changed(value);
signal model_rotation_changed(value);
signal model_scale_changed(value);
signal model_interactable_changed(value);
signal model_material_override_changed(value);

func _ready() -> void :
	model_override_material.get_popup().add_item("None", -1);
	for i in range(0, MaterialLibrary.materials.size()) :
		var material_name : String = (MaterialLibrary.get_material(i) as Material).resource_path
		material_name = material_name.rsplit("/", true, 1)[1];
		material_name = material_name.split(".", true, 1)[0];
		model_override_material.get_popup().add_item(material_name, i);

func set_target_model(model : Model3D) -> void :
	target_model = model;
	model_name.text = target_model.inspector_name;
	
	model_transform.set_model_transform(target_model.global_transform.origin, target_model.rotation_degrees, target_model.scale.x);
	model_interactable.button_pressed = model.model_interactable;
	model_override_material.selected = target_model.override_material_index + 1;

	set_model_material_override(target_model.override_material_index, true);

func fold_item(override : bool = false, value : bool = true) -> void :
	if override == true :
		target_model.inspector_unfolded = value;
		fold_container.visible = value;
		btn_fold.button_pressed = value;
	else :
		target_model.set("inspector_unfolded", btn_fold.pressed);
		fold_container.visible = target_model.inspector_unfolded;

func delete_model() -> void :
	target_model_manager.remove_model(target_model);

func set_model_position(value : Vector3) -> void :
	target_model.global_transform.origin = value;

func set_model_rotation(value : Vector3) -> void :
	target_model.rotation_degrees = value;

func set_model_scale(value : float) -> void :
	target_model.scale = Vector3.ONE * value;

func set_model_interactable(value : bool) -> void :
	target_model.set_model_interactable(value);
	
func update_model_interactable_changed(value : bool) -> void :
	model_interactable.button_pressed = value;

func set_model_material_override(value : int, is_correct_value : bool = false) -> void :
	if is_correct_value == true :
		target_model.set_override_material(value);
	else :
		target_model.set_override_material(value - 1);

func update_inspector_material_override(value : int) -> void :
	model_override_material.selected = value + 1;
