extends SketchTool
class_name MaterialPainter

var current_material_index	: int			= -1;

onready var interaction_area	: Area		= get_node("Area");
onready var material_preview	: MeshInstance	= get_node("Graphics/Material_Preview");

func _ready() -> void :
	switch_tool_mode();

func start_tool_use() -> void :
	.start_tool_use();
	if interacted_object != null :
		pass;
		(interacted_object as Model3D).set_override_material(current_material_index);

func stop_tool_use() -> void :
	.stop_tool_use();

func switch_tool_mode(invert_switch : bool = false) -> void :
	if invert_switch == true :
		current_material_index -= 1;
		if current_material_index < -1 :
			current_material_index = MaterialLibrary.materials.size() - 1;
	else :
		current_material_index += 1;
		if current_material_index >= MaterialLibrary.materials.size() :
			current_material_index = -1;

	if current_material_index < 0 :
		material_preview.material_override = MaterialLibrary.materials[0];
		_tool_mode_name = "none";
	else :
		material_preview.material_override = MaterialLibrary.materials[current_material_index];
		
		var material_name : String = (MaterialLibrary.materials[current_material_index] as Material).resource_path;
		material_name = material_name.rsplit("/", true, 1)[1];
		material_name = material_name.rsplit(".")[0];
		material_name = material_name.replace("_", " ");
		
		_tool_mode_name = material_name + " texture";
	
	.switch_tool_mode(invert_switch);
