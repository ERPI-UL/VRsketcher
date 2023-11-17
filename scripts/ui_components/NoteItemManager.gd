extends Control

export(NodePath) var notes_manager_path : NodePath = "";

var note_item_template : PackedScene = load("res://scenes/ui_components/notes_item/NoteItem.tscn");

onready var target_notes_manager : NotesManager = get_node(notes_manager_path);

func _ready():
	target_notes_manager.connect("notes_list_changed", self, "refresh_notes_list");
	refresh_notes_list();

func refresh_notes_list() -> void :
	for child in get_children() :
		child.queue_free();

	if target_notes_manager.notes.size() > 0 :
		for i in range(0, target_notes_manager.notes.size()) :
			var item : NoteItem = note_item_template.instance();
			add_child(item);

			item.target_notes_manager = target_notes_manager;
			item.set_target_note(target_notes_manager.notes[i]);
			item.fold_item(true, (target_notes_manager.notes[i] as Note3D).inspector_unfolded);

			#Connect to linked Model3D signals to update the inspector when the Model3D is updated from within the scene
			(target_notes_manager.notes[i] as Note3D).connect("position_changed", item.note_transform, "update_inspector_position");
			(target_notes_manager.notes[i] as Note3D).connect("rotation_changed", item.note_transform, "update_inspector_rotation");
			(target_notes_manager.notes[i] as Note3D).connect("scale_changed", item.note_transform, "update_inspector_scale");
			(target_notes_manager.notes[i] as Note3D).connect("note_interactable_changed", item, "update_note_interactable_changed");
