extends Control
class_name NoteItem

var target_note : Note3D = null;
var target_notes_manager : NotesManager = null;

@onready var btn_fold : CheckButton = get_node("VBoxContainer/HBoxContainer/Fold");

@onready var fold_container : Control = get_node("VBoxContainer/VBoxContainer");

@onready var note_name : LineEdit = get_node("VBoxContainer/HBoxContainer/Note_Name");
@onready var note_text : TextEdit = get_node("VBoxContainer/VBoxContainer/Note_Text");
@onready var note_transform : ModelTransform = get_node("VBoxContainer/VBoxContainer/Note_Transform");
@onready var note_interactable : CheckBox = get_node("VBoxContainer/VBoxContainer/HBoxContainer/interactable_switch");

signal note_position_changed(value);
signal note_rotation_changed(value);
signal note_scale_changed(value);
signal note_name_changed(value);
signal note_text_changed(value);
signal note_interactable_changed(value);

func _ready() -> void :
	pass;

func set_target_note(note : Note3D) -> void :
	target_note = note;
	note_name.text = target_note.inspector_name;
	note_text.text = target_note.note_text;

	note_transform.set_model_transform(target_note.global_transform.origin, target_note.rotation_degrees, target_note.scale.x);
	note_interactable.button_pressed = note.note_interactable;

func fold_item(override : bool = false, value : bool = true) -> void :
	if override == true :
		target_note.inspector_unfolded = value;
		fold_container.visible = value;
		btn_fold.button_pressed = value;
	else :
		target_note.inspector_unfolded = btn_fold.get("pressed");
		fold_container.visible = target_note.inspector_unfolded;

func delete_note() -> void :
	target_notes_manager.remove_note(target_note);

func set_note_name(value : String) -> void :
	target_note.set_inspector_name(value);

func set_note_text() -> void :
	target_note.set_text(note_text.text);

func set_note_position(value : Vector3) -> void :
	target_note.global_transform.origin = value;

func set_note_rotation(value : Vector3) -> void :
	target_note.rotation_degrees = value;

func set_note_scale(value : float) -> void :
	target_note.scale = Vector3.ONE * value;

func set_note_interactable(value : bool) -> void :
	target_note.set_model_interactable(value);

func update_note_interactable_changed(value : bool) -> void :
	note_interactable.button_pressed = value;
