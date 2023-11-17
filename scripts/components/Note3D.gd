extends Spatial
class_name Note3D

onready var note_xr_interface	: XRInterface	= get_node("XRInterface");

var note_text				: String	= "";

var inspector_name			: String	= "Note";
var inspector_unfolded		: bool		= false;
var note_interactable		: bool		= true;

var show_arrow_top_left		: bool		= false;
var show_arrow_top			: bool		= false;
var show_arrow_top_right	: bool		= false;
var show_arrow_left			: bool		= false;
var show_arrow_right		: bool		= false;
var show_arrow_bottom_left	: bool		= false;
var show_arrow_bottom		: bool		= false;
var show_arrow_bottom_right	: bool		= false;

signal position_changed(new_value);
signal rotation_changed(new_value);
signal scale_changed(new_value);
signal inspector_name_changed(new_value);
signal text_changed(new_value);
signal note_interactable_changed(new_value);

func _ready() -> void :
	call_deferred("update_arrows_visibility");

func set_position(new_value : Vector3) -> void :
	global_transform.origin = new_value;
	emit_signal("position_changed", new_value);

func set_rotation(new_value : Vector3) -> void :
	rotation_degrees = new_value;
	emit_signal("rotation_changed", new_value);

func set_scale(new_value : Vector3) -> void :
	scale = new_value;
	emit_signal("scale_changed", new_value);
	
func set_inspector_name(new_value : String) -> void :
	inspector_name = new_value;
	(get_node("XRInterface/Viewport/GridContainer/Panel/MarginContainer/VBoxContainer/Label") as Label).text = inspector_name;
	emit_signal("inspector_name_changed", new_value);

func set_text(new_value : String) -> void :
	note_text = new_value;
	(get_node("XRInterface/Viewport/GridContainer/Panel/MarginContainer/VBoxContainer/RichTextLabel") as RichTextLabel).text = note_text;
	emit_signal("text_changed", new_value);

func update_arrows_visibility() -> void :
	(get_node("XRInterface/Viewport/GridContainer/arrow_top_left/TextureRect") as Control).visible = show_arrow_top_left;
	(get_node("XRInterface/Viewport/GridContainer/arrow_top/TextureRect") as Control).visible = show_arrow_top;
	(get_node("XRInterface/Viewport/GridContainer/arrow_top_right/TextureRect") as Control).visible = show_arrow_top_right;
	(get_node("XRInterface/Viewport/GridContainer/arrow_left/TextureRect") as Control).visible = show_arrow_left;
	(get_node("XRInterface/Viewport/GridContainer/arrow_right/TextureRect") as Control).visible = show_arrow_right;
	(get_node("XRInterface/Viewport/GridContainer/arrow_bottom_left/TextureRect") as Control).visible = show_arrow_bottom_left;
	(get_node("XRInterface/Viewport/GridContainer/arrow_bottom/TextureRect") as Control).visible = show_arrow_bottom;
	(get_node("XRInterface/Viewport/GridContainer/arrow_bottom_right/TextureRect") as Control).visible = show_arrow_bottom_right;

func update_interaction_area() -> void :
	if note_xr_interface == null :
		return;
	note_xr_interface.monitorable = note_interactable;

func set_note_interactable(value : bool) -> void :
	note_interactable = value;
	if note_xr_interface != null :
		note_xr_interface.monitorable = note_interactable;
