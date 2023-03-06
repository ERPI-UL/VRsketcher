extends Node

var imported_models : Array = [];

signal imported_model_list_changed();

func _ready() -> void :
	MaterialLibrary.connect("material_selection_changed", self, "set_model_material");

func add_model(model : ImportedModel) -> void :
	imported_models.append(model);
	emit_signal("imported_model_list_changed");

func remove_model(model : ImportedModel) -> void :
	imported_models.remove(imported_models.find(model));
	model.queue_free();
	emit_signal("imported_model_list_changed");

func set_model_material(new_material : Material) -> void :
	for model in imported_models :
		(model as ImportedModel).set_material(new_material);
