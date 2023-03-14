extends Node
class_name ModelsManager

var models : Array = [];

signal models_list_changed();

func add_model(model : Model3D) -> void :
	models.append(model);
	emit_signal("models_list_changed");

func remove_model(model : Model3D) -> void :
	models.remove(models.find(model));
	model.queue_free();
	emit_signal("models_list_changed");
