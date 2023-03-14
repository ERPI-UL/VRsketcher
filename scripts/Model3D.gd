extends Spatial
class_name Model3D

var inspector_name		: String	= "";
var inspector_unfolded	: bool		= false;
var model_filename		: String	= "";

var material			: Material	= null;

var aabb				: AABB		= AABB(Vector3.ZERO, Vector3.ZERO);

var meshes : Array = [];

signal position_changed(new_value);
signal rotation_changed(new_value);
signal scale_changed(new_value);

func _ready() -> void :
	MaterialLibrary.connect("material_selection_changed", self, "set_material");
	set_material(MaterialLibrary.get_current_material());

func set_position(new_value : Vector3) -> void :
	global_transform.origin = new_value;
	emit_signal("position_changed", new_value);

func set_rotation(new_value : Vector3) -> void :
	rotation_degrees = new_value;
	emit_signal("rotation_changed", new_value);

func set_scale(new_value : Vector3) -> void :
	scale = new_value;
	emit_signal("scale_changed", new_value);

func add_mesh(value : Mesh) -> void :
	var m : MeshInstance = MeshInstance.new();
	m.mesh = value;
	meshes.append(value);
	add_child(m);
	aabb = aabb.merge(m.get_aabb());
	refresh_material();

func set_material(value : Material) -> void :
	material = value;
	refresh_material();

func refresh_material() -> void :
	for c in get_children() :
		if c is MeshInstance :
			c.material_override = material;

func get_model_aabb() -> AABB :
	return aabb;

