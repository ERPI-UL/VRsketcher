extends SketchTool
class_name Pen

const paint_materials : Array = [
	"res://materials/paint_materials/Blue.tres",
	"res://materials/paint_materials/Red.tres",
	"res://materials/paint_materials/Yellow.tres",
	"res://materials/paint_materials/Green.tres",
	"res://materials/paint_materials/Orange.tres",
	"res://materials/paint_materials/Purple.tres",
	"res://materials/paint_materials/White.tres",
	"res://materials/paint_materials/Black.tres"
]

export(float)	var paint_thickness				: float	= 0.005;
export(float)	var paint_distance_threshold	: float	= 0.01;

export(int, LAYERS_3D_PHYSICS)	var paint_collision_layer		: int	= 0;
export(int, LAYERS_3D_PHYSICS)	var paint_collision_mask		: int	= 0;

var is_drawing				: bool			= false;
var current_paint_index		: int			= -1;
var current_line_renderer	: Line			= null;
var paint_last_position		: Vector3		= Vector3.ZERO;

onready var pen_tip			: MeshInstance	= get_node("Graphics/Tip");

func _ready() -> void :
	._ready();
	set_tool_sub_mode(0);

func _physics_process(_delta : float) -> void :
	if is_drawing == true :
		if current_line_renderer != null :
			if pen_tip.global_transform.origin.distance_to(paint_last_position) >= paint_distance_threshold :
				paint_last_position = pen_tip.global_transform.origin;
				current_line_renderer.add_point(paint_last_position);

func load_tool_modes() -> void :
	.load_tool_modes();
	modes_main = [
		["Libre"],
		["Ligne"],
		["Cercle"]
	];

	modes_sub = [
		["Bleu",	load(paint_materials[0])],
		["Rouge",	load(paint_materials[1])],
		["Jaune",	load(paint_materials[2])],
		["Vert",	load(paint_materials[3])],
		["Orange",	load(paint_materials[4])],
		["Violet",	load(paint_materials[5])],
		["Blanc",	load(paint_materials[6])],
		["Noir",	load(paint_materials[7])]
	];

func start_tool_use() -> void :
	.start_tool_use();

	if is_drawing == false :
		is_drawing = true;

		paint_last_position = pen_tip.global_transform.origin;

		current_line_renderer = Line.new();
		(get_tree().root.get_node("VRSketcher") as VRSketcher).scene_lines.add_child(current_line_renderer);
		current_line_renderer.add_point(paint_last_position)
		current_line_renderer.material_index = mode_sub_index;
		current_line_renderer.material_override = modes_sub[mode_sub_index][1] as Material;
		current_line_renderer.thickness = paint_thickness;

func stop_tool_use() -> void :
	.stop_tool_use();

	if is_drawing == true :
		is_drawing = false;
		current_line_renderer.commit();

		(current_line_renderer.get_child(0) as CollisionObject).collision_layer = paint_collision_layer;
		(current_line_renderer.get_child(0) as CollisionObject).collision_mask = paint_collision_mask;

		yield(get_tree(), "idle_frame");
		if current_line_renderer.get_child_count() < 0 :
			current_line_renderer.queue_free();
		current_line_renderer = null;

func set_tool_sub_mode(mode_index : int) -> void :
	.set_tool_sub_mode(mode_index);
	
	var paint_material : Material = modes_sub[mode_sub_index][1] as Material;
	
	pen_tip.material_override = paint_material;
	
	var material_name : String = paint_material.resource_path;
	material_name = material_name.rsplit("/", true, 1)[1];
	material_name = material_name.rsplit(".")[0];
	
	EventBus.emit_signal("paint_color_changed", (paint_material as SpatialMaterial).albedo_color);
