extends Area
class_name ModelInteractionArea

export(int, LAYERS_3D_PHYSICS)	var interaction_collision_layer		: int	= 0;
export(int, LAYERS_3D_PHYSICS)	var interaction_collision_mask		: int	= 0;

func _ready():
	collision_layer = interaction_collision_layer;
	collision_mask = interaction_collision_mask;

func set_interaction_area(position : Vector3, size : Vector3) -> void :
	(get_node("CollisionShape") as Spatial).translation = position + size;
	(get_node("CollisionShape").shape as BoxShape).extents = size;
