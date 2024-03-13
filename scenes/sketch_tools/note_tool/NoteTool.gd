extends SketchTool
class_name NoteTool

@onready var note_template : PackedScene = load("res://scenes/sketch_tools/note_tool/Note3D.tscn");

var start_position			: Vector3		= Vector3.ZERO;
var end_position			: Vector3		= Vector3.ZERO;

var current_note			: Note3D	= null;

@onready var tool_gizmo		: Node3D		= get_node("Graphics/Pen_Gizmo");

func _ready() -> void :
	super._ready();

func _physics_process(_delta : float) -> void :
	if tool_in_use == true :
		match (modes_main[mode_main_index] as String) :
			"Note" :
				pass;
			_ :
				pass;

		if current_note != null :
			end_position = tool_gizmo.global_transform.origin;
			
			var d : float = start_position.distance_to(end_position);
			var size : float = 0.2;
			
			if d > 0.2 :
				var diagonal : Vector3 = start_position.direction_to(end_position) * d;
				
				var h_start : Vector3 = Vector3(start_position.x, 0.0, start_position.z);
				var h_end : Vector3 = Vector3(end_position.x, 0.0, end_position.z);

				var v_start : Vector3 = Vector3(0.0, start_position.y, 0.0);
				var v_end : Vector3 = Vector3(0.0, end_position.y, 0.0);

				size = max(h_start.distance_to(h_end), v_start.distance_to(v_end));

				var x_axis : Vector3 = Vector3(diagonal.x, 0.0, diagonal.z).normalized();
				var y_axis : Vector3 = Vector3.UP;
				var z_axis : Vector3 = x_axis.cross(y_axis);
				current_note.global_transform.basis = Basis(x_axis, y_axis, z_axis);
				
				if CameraData.direction_forward.dot(current_note.global_transform.basis.z) > 0.0 :
					current_note.rotate_y(deg_to_rad(180.0));

			current_note.global_transform.origin = (start_position + end_position) / 2.0;
			

			
			current_note.scale = Vector3(size, size, 1.0);

func load_tool_modes() -> void :
	super.load_tool_modes();
	modes_main = [
		["Simple"],

		["Flèche Haut"],
		["Flèche Bas"],
		["Flèche Gauche"],
		["Flèche Droite"],

		["Flèche Haut Gauche"],
		["Flèche Haut Droit"],
		["Flèche Bas Gauche"],
		["Flèche Bas Droit"]
	];

	modes_sub = [
		[""]
	];

func start_tool_use() -> void :
	super.start_tool_use();
	start_position = tool_gizmo.global_transform.origin;
	end_position = tool_gizmo.global_transform.origin;

	current_note = note_template.instantiate();
	current_note.inspector_name = "Note";

	match mode_main_index :
		0 :
			pass;
		1 :
			current_note.show_arrow_top = true;
		2 :
			current_note.show_arrow_bottom = true;
		3 :
			current_note.show_arrow_left = true;
		4 :
			current_note.show_arrow_right = true;
		5 :
			current_note.show_arrow_top_left = true;
		6 :
			current_note.show_arrow_top_right = true;
		7 :
			current_note.show_arrow_bottom_left = true;
		8 :
			current_note.show_arrow_bottom_right = true;

	(get_tree().root.get_node("VRSketcher") as VRSketcher).scene_notes.add_child(current_note);

func stop_tool_use() -> void :
	super.stop_tool_use();
	if current_note != null :
		if start_position.distance_to(end_position) < 0.2 :
			current_note.queue_free();
		else :
			(get_tree().root.get_node("VRSketcher") as VRSketcher).manager_notes.add_note(current_note);
			current_note.global_transform.basis = Basis(CameraData.direction_right, CameraData.direction_up, -CameraData.direction_forward);
		current_note = null;

