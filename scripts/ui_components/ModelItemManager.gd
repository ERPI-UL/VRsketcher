extends Control

export(NodePath) var models_manager_path : NodePath = "";

var model_item_template : PackedScene = load("res://scenes/ui_components/Model_Item.tscn");

onready var target_models_manager : ModelsManager = get_node(models_manager_path);

func _ready():
	target_models_manager.connect("models_list_changed", self, "refresh_model_list");
	refresh_model_list();

func refresh_model_list() -> void :
	for child in get_children() :
		child.queue_free();

	if target_models_manager.models.size() > 0 :
		for i in range(0, target_models_manager.models.size()) :
			var item : ModelItem = model_item_template.instance();
			add_child(item);
			item.target_model_manager = target_models_manager;
			item.set_target_model(target_models_manager.models[i]);
			item.fold_item(true, (target_models_manager.models[i] as Model3D).inspector_unfolded);

			#Connect to linked Model3D signals to update the inspector when the Model3D is updated from within the scene
			(target_models_manager.models[i] as Model3D).connect("position_changed", item.model_transform, "update_inspector_position");
			(target_models_manager.models[i] as Model3D).connect("rotation_changed", item.model_transform, "update_inspector_rotation");
			(target_models_manager.models[i] as Model3D).connect("scale_changed", item.model_transform, "update_inspector_scale");
			(target_models_manager.models[i] as Model3D).connect("material_override_changed", item, "update_inspector_material_override");

