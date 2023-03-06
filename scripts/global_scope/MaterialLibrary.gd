extends Node

export(Array, Resource) var materials : Array = [];

var current_material_index : int = 0;

export(int, LAYERS_3D_PHYSICS)	var paint_collision_layer		: int	= 0;
export(int, LAYERS_3D_PHYSICS)	var paint_collision_mask		: int	= 0;

signal material_selection_changed(new_material);

func get_current_material() -> Material :
	return materials[current_material_index];
	
func switch_material() -> void :
	current_material_index += 1;
	if current_material_index >= materials.size() :
		current_material_index = 0;
	emit_signal("material_selection_changed", get_current_material());
