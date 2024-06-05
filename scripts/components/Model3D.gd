extends Spatial
class_name Model3D

onready var model_interaction_area_template	: PackedScene	= load("res://scenes/ModelInteractionArea.tscn");

var is_imported								: bool			= false;

var inspector_name							: String		= "";
var inspector_unfolded						: bool			= false;
var model_filename							: String		= "";

var model_interactable						: bool			= true;
var model_visible							: bool			= true;

var material								: Material		= null;

var aabb									: AABB			= AABB(Vector3.ZERO, Vector3.ZERO);

var meshes : Array = [];
var interaction_area : ModelInteractionArea = null;

var override_material_index : int = -1;
var smooth_shading : bool = false;
var model_texture : Texture = null;
var texture_material : SpatialMaterial = null;

signal position_changed(new_value);
signal rotation_changed(new_value);
signal scale_changed(new_value);
signal material_override_changed(new_value);
signal model_interactable_changed(new_value);

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

func set_override_material(new_value : int) -> void :
	if model_texture == null :
		override_material_index = new_value;
		set_material(null);
		emit_signal("material_override_changed", new_value);

func add_mesh(value : Mesh) -> void :
	var m : MeshInstance = MeshInstance.new();
	m.mesh = value;
	meshes.append(value);
	add_child(m);
	update_aabb();
	refresh_material();

func get_model_aabb() -> AABB :
	return aabb;

func update_aabb() -> void :
	aabb = AABB(Vector3.ZERO, Vector3.ZERO);
	for m in meshes :
		aabb = aabb.merge(m.get_aabb());

func update_interaction_area() -> void :
	if interaction_area != null :
		interaction_area.queue_free();
	interaction_area = model_interaction_area_template.instance();
	interaction_area.monitorable = model_interactable;
	add_child(interaction_area);
	interaction_area.set_interaction_area(get_model_aabb().position, get_model_aabb().size / 2.0);

func set_model_interactable(value : bool) -> void :
	model_interactable = value;
	if interaction_area != null :
		interaction_area.monitorable = model_interactable;

func set_model_visible(value : bool) -> void :
	model_visible = value;
	for c in get_children() :
		if c is MeshInstance :
			c.visible = value;
	set_model_interactable(model_interactable && value);

func set_material(value : Material) -> void :
	if model_texture == null :
		if override_material_index >= 0 :
			material = MaterialLibrary.get_material(override_material_index);
		else :
			if value == null :
				material = MaterialLibrary.get_current_material();
			else :
				material = value;
	refresh_material();

func refresh_material() -> void :
	for c in get_children() :
		if c is MeshInstance :
			if texture_material == null :
				c.set_surface_material(0, material);
			else :
				c.material_override = texture_material;

func set_overlay_material(material : Material) -> void :
	for c in get_children() :
		if c is MeshInstance :
			c.material_overlay = material;

func set_model_texture(texture : Texture) -> void :
	model_texture = texture;
	texture_material = SpatialMaterial.new();
	texture_material.albedo_texture = model_texture;
	texture_material.params_cull_mode = SpatialMaterial.CULL_DISABLED;
	refresh_material();
