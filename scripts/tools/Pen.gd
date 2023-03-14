extends SketchTool
class_name Pen

export(float)					var paint_thickness				: float	= 0.005;
export(float) 					var paint_distance_threshold	: float	= 0.01;

var is_drawing				: bool		= false;
var current_paint_index		: int		= -1;
var current_line_renderer	: Line		= null;
var paint_last_position		: Vector3	= Vector3.ZERO;

onready var pen_tip : MeshInstance = get_node("Graphics/Tip");

func _ready() -> void :
	switch_tool_mode();

func _physics_process(_delta : float) -> void :
	if is_drawing == true :
		if current_line_renderer != null :
			if pen_tip.global_transform.origin.distance_to(paint_last_position) >= paint_distance_threshold :
				paint_last_position = pen_tip.global_transform.origin;
				current_line_renderer.add_point(paint_last_position);

func start_tool_use() -> void :
	.start_tool_use();

	if is_drawing == false :
		is_drawing = true;

		paint_last_position = pen_tip.global_transform.origin;

		current_line_renderer = Line.new();
		(get_tree().root.get_node("VRSketcher") as VRSketcher).scene_lines.add_child(current_line_renderer);
		current_line_renderer.add_point(paint_last_position)
		current_line_renderer.material_index = current_paint_index;
		current_line_renderer.material_override = PaintMaterials.materials[current_line_renderer.material_index];
		current_line_renderer.thickness = paint_thickness;

func stop_tool_use() -> void :
	.stop_tool_use();

	if is_drawing == true :
		is_drawing = false;
		current_line_renderer.commit();
		yield(get_tree(), "idle_frame");
		if current_line_renderer.get_child_count() < 0 :
			current_line_renderer.queue_free();
		current_line_renderer = null;

func switch_tool_mode() -> void :
	current_paint_index += 1;
	if current_paint_index >= PaintMaterials.materials.size() :
		current_paint_index = 0;

	pen_tip.material_override = PaintMaterials.materials[current_paint_index];
	EventBus.emit_signal("paint_color_changed", (PaintMaterials.materials[current_paint_index] as SpatialMaterial).albedo_color);
	
	var material_name : String = (PaintMaterials.materials[current_paint_index] as Material).resource_path;
	material_name = material_name.rsplit("/", true, 1)[1];
	material_name = material_name.rsplit(".")[0];
	
	_tool_mode_name = material_name + " Pen";
	
	.switch_tool_mode();
