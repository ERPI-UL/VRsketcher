extends Control
class_name ModelItemManager

var model_item_template : PackedScene = load("res://scenes/ui_components/model_item/ModelItem.tscn");

func refresh_model_list(list : Array, manager) -> void :
	for child in get_children() :
		child.queue_free();

	for i in range(0, list.size()) :
		var item : ModelItem = model_item_template.instance();
		add_child(item);
		item.target_model_manager = manager;
		item.set_target_model(list[i]);
		item.fold_item(true, (list[i] as Model3D).inspector_unfolded);

		#Connect to linked Model3D signals to update the inspector when the Model3D is updated from within the scene
		if (list[i] as Model3D).connect("position_changed", item.model_transform, "update_inspector_position") != OK :
			print("Can't connect Model3D signal position_changed");
		if (list[i] as Model3D).connect("rotation_changed", item.model_transform, "update_inspector_rotation") != OK :
			print("Can't connect Model3D signal rotation_changed");
		if (list[i] as Model3D).connect("scale_changed", item.model_transform, "update_inspector_scale") != OK :
			print("Can't connect Model3D signal scale_changed");
		if (list[i] as Model3D).connect("model_interactable_changed", item, "update_model_interactable_changed") != OK :
			print("Can't connect Model3D signal model_interactable_changed");
		if (list[i] as Model3D).connect("material_override_changed", item, "update_inspector_material_override") != OK :
			print("Can't connect Model3D signal material_override_changed");
