extends Node
class_name NotesManager

var notes : Array = [];

signal notes_list_changed();

func add_note(note : Note3D) -> void :
	notes.append(note);
	emit_signal("notes_list_changed");

func remove_note(note : Note3D) -> void :
	notes.remove(notes.find(note));
	note.queue_free();
	emit_signal("notes_list_changed");

func clear_notes() -> void :
	for n in notes :
		if n != null :
			n.queue_free();
	notes.clear();
	emit_signal("notes_list_changed");
