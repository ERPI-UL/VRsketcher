extends Area
class_name ModelInteractionArea

export(int, LAYERS_3D_PHYSICS)	var interaction_collision_layer		: int	= 0;
export(int, LAYERS_3D_PHYSICS)	var interaction_collision_mask		: int	= 0;

func _ready():
	collision_layer = interaction_collision_layer;
	collision_mask = interaction_collision_mask;

func set_interaction_area(position : Vector3, size : Vector3) -> void :
	var interaction_area_min_size : float = 0.03;

	var abs_diff : Vector3 = Vector3.ONE * interaction_area_min_size - size;
	abs_diff = Vector3(max(abs_diff.x, 0.0), max(abs_diff.y, 0.0), max(abs_diff.z, 0.0));

	var area_size : Vector3 = Vector3(
		max(interaction_area_min_size, size.x),
		max(interaction_area_min_size, size.y),
		max(interaction_area_min_size, size.z)
	);

	(get_node("CollisionShape") as Spatial).translation = position + area_size - (abs_diff);
	(get_node("CollisionShape").shape as BoxShape).extents = area_size;
