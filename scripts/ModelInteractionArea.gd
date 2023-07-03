extends Area
class_name ModelInteractionArea

export(int, LAYERS_3D_PHYSICS)	var interaction_collision_layer		: int	= 0;
export(int, LAYERS_3D_PHYSICS)	var interaction_collision_mask		: int	= 0;

func _ready():
	collision_layer = interaction_collision_layer;
	collision_mask = interaction_collision_mask;

func set_interaction_area(position : Vector3, size : Vector3) -> void :
	var interaction_area_min_size : float = 0.05;
	var area_size : Vector3 = Vector3(
		max(interaction_area_min_size, size.x),
		max(interaction_area_min_size, size.y),
		max(interaction_area_min_size, size.z)
	);

	(get_node("CollisionShape") as Spatial).translation = position + area_size;
	(get_node("CollisionShape").shape as BoxShape).extents = area_size;
