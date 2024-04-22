extends VRSketcher

var camera : Camera = null;

export(NodePath) var controller_viewport_path	: NodePath			= "";

onready var project_manager						: Control			= get_node("Interface/ProjectManager");
onready var vr_sketcher_interface				: Control			= get_node("Interface/VRSketcherInterface");
onready var controller_selection				: Control			= get_node("Interface/ControllerSelection");

onready var import_smooth_shading				: CheckButton		= get_node("Interface/ModelImportWindow/Import_Panel/Import_Smooth_Shading");


func _ready() -> void :
	if Project.connect("open_project", self, "open_project") != OK :
		print("Can't connect Project signal open_project");

	project_manager.visible = true;
	vr_sketcher_interface.visible = false;
	controller_selection.visible = false;

func set_controller(controller : Node, enable_vr : bool) -> void :
	for child in get_children_recursive(controller) :
		if child is Camera :
			camera = child;
			break;

	(get_node(controller_viewport_path) as Viewport).arvr = enable_vr;
	
	get_node(controller_viewport_path).add_child(controller);
	
	EventBus.emit_signal("scene_drawn_models_list_updated", manager_drawn_models.models, manager_drawn_models);
	EventBus.emit_signal("scene_imported_models_list_updated", manager_imported_models.models, manager_imported_models);
	EventBus.emit_signal("scene_notes_list_updated", manager_notes.notes, manager_notes);

func get_children_recursive (root : Node) -> Array :
	var children : Array = [];
	
	for child in root.get_children():
		children.append(child);
		if child.get_child_count() > 0 :
			children.append_array(get_children_recursive(child));
		
	return children;

func set_environment_exposure(value : float = 1.0) -> void :
	.set_environment_exposure(value);

func open_project() -> void :
	.open_project();

	if project_manager != null && is_instance_valid(project_manager) == true :
		project_manager.visible = false;

	if vr_sketcher_interface != null && is_instance_valid(vr_sketcher_interface) == true :
		vr_sketcher_interface.visible = true;

	if controller_selection != null && is_instance_valid(controller_selection) == true :
		controller_selection.visible = true;

func import_model_from_path(model_path : String, smooth_shading : bool = false) -> void :
	.import_model_from_path(model_path, smooth_shading || import_smooth_shading.pressed);