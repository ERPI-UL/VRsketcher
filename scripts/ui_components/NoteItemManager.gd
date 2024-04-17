extends Control
class_name NoteItemManager

var note_item_template : PackedScene = load("res://scenes/ui_components/notes_item/NoteItem.tscn");

func refresh_notes_list(list : Array, manager) -> void :
	for child in get_children() :
		child.queue_free();

	for i in range(0, list.size()) :
		var item : NoteItem = note_item_template.instance();
		add_child(item);

		item.target_notes_manager = manager;
		item.set_target_note(list[i]);
		item.fold_item(true, (list[i] as Note3D).inspector_unfolded);

		#Connect to linked Note3D signals to update the inspector when the Model3D is updated from within the scene
		
		if (list[i] as Note3D).connect("position_changed", item.note_transform, "update_inspector_position") != OK :
			print("Can't connect Note3D signal position_changed");
		if (list[i] as Note3D).connect("rotation_changed", item.note_transform, "update_inspector_rotation") != OK :
			print("Can't connect Note3D signal rotation_changed");
		if (list[i] as Note3D).connect("scale_changed", item.note_transform, "update_inspector_scale") != OK :
			print("Can't connect Note3D signal scale_changed");
		if (list[i] as Note3D).connect("note_interactable_changed", item, "update_note_interactable_changed") != OK :
			print("Can't connect Note3D signal note_interactable_changed");
