extends MeshInstance
class_name Line

const EPSILON : float = 0.1;

var points : Array = [];
export(float) var thickness : float = 0.1 setget set_thickness, get_thickness;
export(bool) var generate_collisions : bool = true;

var material_index : int = -1;

func _ready() -> void:
	extra_cull_margin = 1000.0;
	set_cast_shadows_setting(GeometryInstance.SHADOW_CASTING_SETTING_OFF);

func add_point(new_point : Vector3) -> void :
	points.append(new_point);
	render_line();
	
func add_points_from_array(points_array : Array) -> void :
	for point in points_array :
		points.append(point);
	render_line();
	commit();

func set_thickness(value : float) -> void :
	thickness = value;
	render_line();
	commit();
	
func get_thickness() -> float :
	return thickness;

func render_line() -> void :
	var surface_tool : SurfaceTool = SurfaceTool.new();
	
	mesh = null;
	
	surface_tool.begin(PrimitiveMesh.PRIMITIVE_TRIANGLES);
	for i in range(points.size()):
		if i + 1 < points.size():
			
			var from_center : Vector3 = points[i] as Vector3;
			var to_center : Vector3 = points[i + 1] as Vector3;
			
			var from_forward : Vector3 = from_center.direction_to(to_center);
			var from_right : Vector3 = from_forward.cross(Vector3.UP);
			var from_up : Vector3 = from_forward.cross(from_right);
			
			if abs(from_forward.dot(Vector3.UP)) >= 1.0 - EPSILON :
				from_forward = Vector3.UP;
				from_right = Vector3.RIGHT;
				from_up = Vector3.FORWARD;

			var to_forward : Vector3 = from_forward;

			if i + 2 < points.size() :
				to_forward = to_center.direction_to(points[i + 2] as Vector3);
				
			var to_right : Vector3 = to_forward.cross(Vector3.UP);
			var to_up : Vector3 = to_forward.cross(to_right);
			
			if abs(to_forward.dot(Vector3.UP)) >= 1.0 - EPSILON :
				to_forward = Vector3.UP;
				to_right = Vector3.RIGHT;
				to_up = Vector3.FORWARD;
			"""
			if i + 3 < points.size() :
				var next_forward : Vector3 = to_forward.direction_to(points[i + 3] as Vector3);
				var next_right : Vector3 = next_forward.cross(Vector3.UP);
				var next_up: Vector3 = next_forward.cross(next_right);
				
				to_right = from_right.linear_interpolate(next_right, 1.0);
				to_up = from_up.linear_interpolate(next_up, 1.0);
			"""
			from_right *= thickness / 2.0;
			from_up *= thickness / 2.0;
			to_right *= thickness / 2.0;
			to_up *= thickness / 2.0;
			
			#Top
			surface_tool.add_vertex(from_center - from_right + from_up);	#1
			surface_tool.add_vertex(to_center - to_right + to_up);			#2
			surface_tool.add_vertex(to_center + to_right + to_up);			#3

			surface_tool.add_vertex(to_center + to_right + to_up);			#3
			surface_tool.add_vertex(from_center - from_right + from_up);	#1
			surface_tool.add_vertex(from_center + from_right + from_up);	#4
			
			#Right
			surface_tool.add_vertex(to_center + to_right + to_up);			#3
			surface_tool.add_vertex(from_center + from_right + from_up);	#4
			surface_tool.add_vertex(to_center + to_right - to_up);			#6

			surface_tool.add_vertex(from_center + from_right + from_up);	#4
			surface_tool.add_vertex(to_center + to_right - to_up);			#6
			surface_tool.add_vertex(from_center + from_right - from_up);	#7

			#Bottom
			surface_tool.add_vertex(from_center - from_right - from_up);
			surface_tool.add_vertex(to_center - to_right - to_up);
			surface_tool.add_vertex(to_center + to_right - to_up);

			surface_tool.add_vertex(to_center + to_right - to_up);
			surface_tool.add_vertex(from_center - from_right - from_up);
			surface_tool.add_vertex(from_center + from_right - from_up);

			#Left
			surface_tool.add_vertex(to_center - to_right + to_up);
			surface_tool.add_vertex(from_center - from_right + from_up);
			surface_tool.add_vertex(to_center - to_right - to_up);

			surface_tool.add_vertex(from_center - from_right + from_up);
			surface_tool.add_vertex(to_center - to_right - to_up);
			surface_tool.add_vertex(from_center - from_right - from_up);
	mesh = surface_tool.commit();

func commit() -> void :
	if generate_collisions == true :
		if points.size() >= 2 :
			if mesh != null :
				for child in get_children() :
					child.queu_free();
				create_trimesh_collision();
