extends SketchTool
class_name MaterialPainter

var current_material_index	: int			= -1;

@onready var interaction_area	: Area3D		= get_node("Area3D");
@onready var material_preview	: MeshInstance3D	= get_node("Graphics/Material_Preview");

func _ready() -> void :
	super._ready();

func load_tool_modes() -> void :
	super.load_tool_modes();
	modes_main = [
		["Peindre"]
	];

	modes_sub = [];
	for m in MaterialLibrary.materials :
		modes_sub.append(((m as StandardMaterial3D).resource_path.rsplit("/", true, 1)[1] as String).split(".")[0]);

func start_tool_use() -> void :
	super.start_tool_use();
	if interacted_object != null :
		pass;
		(interacted_object as Model3D).set_override_material(current_material_index);

func stop_tool_use() -> void :
	super.stop_tool_use();

func set_tool_main_mode(mode_index : int) -> void :
	super.set_tool_main_mode(mode_index);

func set_tool_sub_mode(mode_index : int) -> void :
	current_material_index = mode_index;
	mode_sub_index = mode_index;
	if mode_sub_index < 0 :
		material_preview.material_override = MaterialLibrary.materials[0];
	else :
		material_preview.material_override = MaterialLibrary.materials[current_material_index];
	
	EventBus.call_deferred("emit_signal", "tooltip_update_text", get_tool_mode_name(true));

func get_tool_mode_name(get_sub_mode_name : bool = false) -> String :
	if get_sub_mode_name == true :
		return modes_sub[mode_sub_index][0] as String;
	return get_material_name(MaterialLibrary.materials[current_material_index]) + " texture";

func get_material_name(material : Material) -> String :
		var material_name : String = (MaterialLibrary.materials[current_material_index] as Material).resource_path;
		material_name = material_name.rsplit("/", true, 1)[1];
		material_name = material_name.rsplit(".")[0];
		material_name = material_name.replace("_", " ");
		return material_name;
