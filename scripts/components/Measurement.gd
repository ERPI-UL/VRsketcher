extends Node3D
class_name Measurement

enum MeasureMode {
	DISTANCE	= 0,
	ANGLE		= 1
}

var mode : int = MeasureMode.DISTANCE;

var start_point		: Vector3 = Vector3.ZERO;
var middle_point	: Vector3 = Vector3.ZERO;
var end_point		: Vector3 = Vector3.ZERO;

var start_area		: Area3D = null;
var middle_area		: Area3D = null;
var end_area		: Area3D = null;

var line_renderer	: Line = null;
var measure_text	: Label3D = null;

var use_areas_position : bool = true;

func _ready() -> void :
	var gizmo_position : PackedScene = load("res://scenes/gizmos/Gizmo_Position.tscn");
	var area_shape : SphereShape3D = SphereShape3D.new();
	area_shape.radius = 0.05;
	
	
	start_area = Area3D.new();
	var shape : CollisionShape3D = CollisionShape3D.new();
	shape.shape = area_shape;
	add_child(start_area);
	start_area.name = "start";
	start_area.add_child(shape);
	start_area.add_child(gizmo_position.instantiate());
	start_area.global_transform.origin = start_point;

	end_area = Area3D.new();
	shape = CollisionShape3D.new();
	shape.shape = area_shape;
	add_child(end_area);
	end_area.name = "end";
	end_area.add_child(shape);
	end_area.add_child(gizmo_position.instantiate());
	end_area.global_transform.origin = end_point;

	if mode == MeasureMode.ANGLE :
		middle_area = Area3D.new();
		shape = CollisionShape3D.new();
		shape.shape = area_shape;
		add_child(middle_area);
		middle_area.name = "middle";
		middle_area.add_child(shape);
		middle_area.add_child(gizmo_position.instantiate());
		middle_area.global_transform.origin = middle_point;

	line_renderer = Line.new();
	line_renderer.thickness = 0.01;
	if mode == MeasureMode.DISTANCE :
		line_renderer.material_override = load("res://materials/measurement_materials/distance.tres");
	else :
		line_renderer.material_override = load("res://materials/measurement_materials/angle.tres");
	
	add_child(line_renderer);

	measure_text = Label3D.new();
	measure_text.billboard = StandardMaterial3D.BILLBOARD_FIXED_Y;
	if mode == MeasureMode.DISTANCE :
		measure_text.modulate = Color.DODGER_BLUE;
	else :
		measure_text.modulate = Color.DARK_ORANGE;
	measure_text.font = load("res://assets/fonts/3dFont.tres");
	add_child(measure_text);
	measure_text.scale = Vector3.ONE * 0.1;

func _process(delta : float) -> void :
	if (start_area == null || end_area == null) && mode == MeasureMode.DISTANCE :
		queue_free();
		return;
	elif (start_area == null || middle_area == null || end_area == null) && mode == MeasureMode.ANGLE :
		queue_free();
		return;

	if use_areas_position == true :
		start_point = start_area.global_transform.origin;
		end_point = end_area.global_transform.origin;
		if middle_area != null :
			middle_point = middle_area.global_transform.origin;
	else :
		start_area.global_transform.origin = start_point;
		end_area.global_transform.origin = end_point;
		if middle_area != null :
			middle_area.global_transform.origin = middle_point;
	
	
	if line_renderer != null :
		if mode == MeasureMode.DISTANCE :
			line_renderer.points = [start_point, end_point];
		else :
			line_renderer.points = [start_point, middle_point, end_point];

		line_renderer.render_line();
		
	if measure_text != null :
		if mode == MeasureMode.DISTANCE :
			measure_text.global_transform.origin = (start_point + end_point) / 2.0 + (Vector3.UP * 0.1);
			measure_text.text = "%.2fm" % start_point.distance_to(end_point);
		else :
			measure_text.global_transform.origin = middle_point + (Vector3.UP * 0.1);
			var from_vec : Vector3 = middle_point.direction_to(start_point);
			var to_vec : Vector3 = middle_point.direction_to(end_point);
			
			measure_text.text = "%.2f°" % rad_to_deg(from_vec.angle_to(to_vec));
		

