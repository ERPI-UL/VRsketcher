extends SketchTool
class_name Duplicate

var original_parent : Spatial = null;
var grabbed_object : Spatial = null;

onready var interaction_area	: Area		= get_node("Area");

func _ready() -> void :
	._ready();

func load_tool_modes() -> void :
	.load_tool_modes();
	modes_main = [
		["Dupliquer"]
	];

	modes_sub = [
		[""]
	];

func start_tool_use() -> void :
	.start_tool_use();

	if interacted_object != null :
		grabbed_object = interacted_object;
		original_parent = grabbed_object.get_parent();

func stop_tool_use() -> void :
	.stop_tool_use();

	if grabbed_object != null :
		var original_transform : Transform = grabbed_object.global_transform;

		var copy : Node = grabbed_object.duplicate();
		original_parent.add_child(copy);
		
		copy.is_imported = grabbed_object.is_imported;
		copy.inspector_name = grabbed_object.inspector_name;
		copy.inspector_unfolded = grabbed_object.inspector_unfolded;
		copy.model_filename = grabbed_object.model_filename;
		copy.smooth_shading = grabbed_object.smooth_shading;

		copy.set_model_interactable(grabbed_object.model_interactable);
		copy.set_override_material(grabbed_object.override_material_index);
		
		copy.set_material(grabbed_object.material);
		
		copy.aabb = grabbed_object.get_model_aabb();
		var offset : float = max(copy.aabb.size.x, max(copy.aabb.size.y, copy.aabb.size.z));

		copy.global_transform = original_transform;
		copy.global_transform.origin += CameraData.direction_right * (offset + 0.1);

		copy.set_overlay_material(null);

		var manager : ModelsManager = (get_tree().root.get_node("VRSketcher") as VRSketcher).manager_drawn_models;
		manager.add_model(copy);
		EventBus.emit_signal("scene_drawn_models_list_updated", manager.models, manager);

		grabbed_object = null;
		original_parent = null;
