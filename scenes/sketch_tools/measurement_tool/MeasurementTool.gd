extends SketchTool
class_name MeasurementTool

var start_position			: Vector3		= Vector3.ZERO;
var end_position			: Vector3		= Vector3.ZERO;

var current_measurement		: Measurement	= null;

onready var tool_gizmo		: Spatial		= get_node("Graphics/Gizmo_Position");

func _ready() -> void :
	._ready();

func _physics_process(_delta : float) -> void :
	if tool_in_use == true :
		match (modes_main[mode_main_index] as String) :
			"Distance" :
				pass;
			"Angle" :
				pass;
			_ :
				pass;

		if current_measurement != null :
			end_position = tool_gizmo.global_transform.origin;
			
			current_measurement.start_point = start_position;
			current_measurement.end_point = end_position;
			current_measurement.middle_point = (start_position + end_position) / 2.0;

func load_tool_modes() -> void :
	.load_tool_modes();
	modes_main = [
		["Distance"],
		["Angle"]
	];

	modes_sub = [
		[""]
	];

func start_tool_use() -> void :
	.start_tool_use();
	
	start_position = tool_gizmo.global_transform.origin;
	end_position = tool_gizmo.global_transform.origin;
	
	current_measurement = Measurement.new();
	current_measurement.mode = mode_main_index;
	current_measurement.start_point = start_position;
	current_measurement.end_point = end_position;
	current_measurement.middle_point = (start_position + end_position) / 2.0;
	current_measurement.use_areas_position = false;
	
	(get_tree().root.get_node("VRSketcher") as VRSketcher).scene_measurements.add_child(current_measurement);

func stop_tool_use() -> void :
	.stop_tool_use();
	
	if current_measurement != null :
		current_measurement.use_areas_position = true;
		if start_position.distance_to(end_position) < 0.01 :
			current_measurement.queue_free();
		current_measurement = null;

