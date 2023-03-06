extends Control

var model_item_template : PackedScene = load("res://scenes/ui_components/Model_Item.tscn");

func _ready():
	ImportedModelsManager.connect("imported_model_list_changed", self, "refresh_model_list");
	refresh_model_list();

func refresh_model_list() -> void :
	
	for child in get_children() :
		child.queue_free();
	
	if ImportedModelsManager.imported_models.size() > 0 :
		for i in range(0, ImportedModelsManager.imported_models.size()) :
			var item : ModelItem = model_item_template.instance();
			add_child(item);
			item.set_target_model(ImportedModelsManager.imported_models[i]);
			item.fold_item(true, (ImportedModelsManager.imported_models[i] as ImportedModel).inspector_unfolded);
			
			(ImportedModelsManager.imported_models[i] as ImportedModel).connect("position_changed", item.model_transform, "update_inspector_position");
			(ImportedModelsManager.imported_models[i] as ImportedModel).connect("rotation_changed", item.model_transform, "update_inspector_rotation");
			(ImportedModelsManager.imported_models[i] as ImportedModel).connect("scale_changed", item.model_transform, "update_inspector_scale");
