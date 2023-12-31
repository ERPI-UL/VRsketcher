extends Node
class_name VRSketcher

var camera : Camera = null;

export(NodePath) var controller_viewport_path	: NodePath			= "";
export(NodePath) var camera_sync_path			: NodePath			= "";

onready var world								: Spatial			= get_node("World");
onready var world_environment					: WorldEnvironment	= get_node("WorldEnvironment");

onready var manager_imported_models				: ModelsManager		= get_node("Model_Managers/Imported_Models");
onready var manager_drawn_models				: ModelsManager		= get_node("Model_Managers/Drawn_Models");
onready var manager_notes						: NotesManager		= get_node("Model_Managers/Notes");

onready var hdri_manager						: Node				= get_node("Interface/VRSketcherInterface/HBoxContainer/PanelContainer/VBoxContainer/TabedContainer/Display/VSplitContainer/Environment_HDRI");

onready var scene_imported_models				: Spatial			= get_node("Scene_Objects/Imported_Models");
onready var scene_lines							: Spatial			= get_node("Scene_Objects/Lines");
onready var scene_measurements					: Spatial			= get_node("Scene_Objects/Measurements");
onready var scene_drawn_models					: Spatial			= get_node("Scene_Objects/Drawn_Models");
onready var scene_notes							: Spatial			= get_node("Scene_Objects/Notes");

onready var project_manager						: Control			= get_node("Interface/ProjectManager");
onready var vr_sketcher_interface				: Control			= get_node("Interface/VRSketcherInterface");
onready var controller_selection				: Control			= get_node("Interface/ControllerSelection");

onready var import_smooth_shading				: CheckButton		= get_node("Interface/ModelImportWindow/Import_Panel/Import_Smooth_Shading");


func _ready() -> void :
	(get_node("Interface/VRSketcherInterface/HBoxContainer/PanelContainer/VBoxContainer/TabedContainer/Display/VSplitContainer/VBoxContainer/X_Resolution/SpinBox") as SpinBox).value = get_viewport().size.x;
	(get_node("Interface/VRSketcherInterface/HBoxContainer/PanelContainer/VBoxContainer/TabedContainer/Display/VSplitContainer/VBoxContainer/X_Resolution/SpinBox") as SpinBox).value = get_viewport().size.y;

	Project.connect("open_project", self, "open_project");

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
	
	#(get_node(camera_sync_path) as SpatialSync).node_to_sync_to = camera;

func get_children_recursive (root : Node) -> Array :
	var children : Array = [];
	
	for child in root.get_children():
		children.append(child);
		if child.get_child_count() > 0 :
			children.append_array(get_children_recursive(child));
		
	return children;

func apply_display_settings():
	var x_resolution : float = (get_node("Interface/VRSketcherInterface/HBoxContainer/PanelContainer/VBoxContainer/TabedContainer/Display/VSplitContainer/VBoxContainer/X_Resolution/SpinBox") as SpinBox).value;
	var y_resolution : float = (get_node("Interface/VRSketcherInterface/HBoxContainer/PanelContainer/VBoxContainer/TabedContainer/Display/VSplitContainer/VBoxContainer/Y_Resolution/SpinBox") as SpinBox).value;
	var fov : float = (get_node("Interface/VRSketcherInterface/HBoxContainer/PanelContainer/VBoxContainer/TabedContainer/Display/VSplitContainer/VBoxContainer/FOV/SpinBox") as SpinBox).value;
	var fullscreen = (get_node("Interface/VRSketcherInterface/HBoxContainer/PanelContainer/VBoxContainer/TabedContainer/Display/VSplitContainer/VBoxContainer/Fullscreen/CheckBox") as CheckBox).pressed;

	get_viewport().size = Vector2(x_resolution, y_resolution);
	OS.window_size = Vector2(x_resolution, y_resolution);
	OS.window_fullscreen = fullscreen;
	
	if camera != null :
		camera.fov = fov;

func set_environment_exposure(value : float = 1.0) -> void :
	world_environment.environment.tonemap_exposure = value;
	hdri_manager.current_exposure = value;

func open_project() -> void :
	project_manager.visible = false;
	vr_sketcher_interface.visible = true;
	controller_selection.visible = true;

	if Project.current_project.has("scene_imported_models_data") == true :
		for model_data in Project.current_project["scene_imported_models_data"] :
			import_model(
				model_data,
				true
			);

	if Project.current_project.has("scene_drawn_models_data") == true :
		for model_data in Project.current_project["scene_drawn_models_data"] :
			load_drawn_model(model_data);

	if Project.current_project.has("scene_notes_data") == true :
		for note_data in Project.current_project["scene_notes_data"] :
			load_note(note_data);

	var paint_materials : Array = [
		"res://materials/paint_materials/Blue.tres",
		"res://materials/paint_materials/Red.tres",
		"res://materials/paint_materials/Yellow.tres",
		"res://materials/paint_materials/Green.tres",
		"res://materials/paint_materials/Orange.tres",
		"res://materials/paint_materials/Purple.tres",
		"res://materials/paint_materials/White.tres",
		"res://materials/paint_materials/Black.tres"
	]

	if Project.current_project.has("scene_line_drawings") == true :
		for line_data in Project.current_project["scene_line_drawings"] :
			var line_renderer : Line = Line.new();
			(get_tree().root.get_node("VRSketcher") as VRSketcher).scene_lines.add_child(line_renderer);
			line_renderer.generate_collisions = true;
			line_renderer.thickness = (line_data as Dictionary)["thickness"] as float;
			line_renderer.add_points_from_array((line_data as Dictionary)["points"] as Array);
			line_renderer.material_index = (line_data as Dictionary)["material_index"] as int;
			line_renderer.material_override = load(paint_materials[line_renderer.material_index]);

	if Project.current_project.has("scene_measurements") == true :
		for measurement_data in Project.current_project["scene_measurements"] :
			var measurement : Measurement = Measurement.new();
			measurement.mode = measurement_data["mode"];
			measurement.start_point = measurement_data["start_point"];
			measurement.middle_point = measurement_data["middle_point"];
			measurement.end_point = measurement_data["end_point"];
			(get_tree().root.get_node("VRSketcher") as VRSketcher).scene_measurements.add_child(measurement);

	if Project.current_project.has("current_exposure") == true :
		(get_node("Interface/VRSketcherInterface/HBoxContainer/PanelContainer/VBoxContainer/TabedContainer/Display/VSplitContainer/VBoxContainer/Exposure/SpinBox") as SpinBox).value = Project.current_project["current_exposure"];

func import_model_from_path(model_path : String) -> void :
	import_model(
		{
			"model_filename"		: model_path,
			"inspector_unfolded"	: true,
			"model_interactable"	: true,
			"position"				: Vector3.ZERO,
			"rotation"				: Vector3(0.0, 0.0, 0.0),
			"scale"					: 1.0,
			"size"					: Vector3.ZERO,
			"material_override"		: -1,
			"smooth_shading"		: import_smooth_shading.pressed
		},
		false
	);

func import_model(model_data : Dictionary, local_model : bool = false) -> void :
	print("Loading 3D model file : " + model_data["model_filename"] as String);

	var model_path = model_data["model_filename"] as String;

	if local_model == true :
		model_path = Project.get_imported_models_directory_path() + "/" + model_path;

	var dir : Directory = Directory.new();
	if dir.file_exists(model_path) == true :

		var extension : String = model_path.rsplit(".", true, 1)[1];
		var loaded_meshes : Array = [];

		if extension == "3mf" || extension == "3MF" :
			loaded_meshes = Importer3mf.import_model_file(model_path);
		elif extension == "obj" || extension == "OBJ" :
			loaded_meshes = ImporterObj.import_model_file(model_path, model_data["smooth_shading"]);
		elif extension == "stl" || extension == "STL" :
			loaded_meshes = ImporterStl.import_model_file(model_path, model_data["smooth_shading"]);

		if loaded_meshes.size() > 0 :
			var model : Model3D = Model3D.new();

			var model_name : String = model_path.rsplit("/", true, 1)[1];
			model.model_filename = model_name;

			#Copy model in the import directory if it isn't there yet
			var local_model_file : File = File.new();
			if local_model_file.file_exists(Project.get_imported_models_directory_path() + "/" + model_name) == false :
				if dir.file_exists(model_path) == true :
					dir.copy(model_path, Project.get_imported_models_directory_path() + "/" + model_name);

			#Restore model data
			model_name = model_name.rsplit(".")[0];
			model.is_imported = true;
			model.inspector_name = model_name;

			for mesh in loaded_meshes :
				model.add_mesh(mesh);
			scene_imported_models.add_child(model);

			model.inspector_unfolded = model_data["inspector_unfolded"] as bool;
			model.smooth_shading = model_data["smooth_shading"] as bool;

			model.global_transform.origin = model_data["position"] as Vector3;
			model.rotation_degrees = model_data["rotation"] as Vector3;
			model.scale = Vector3.ONE * model_data["scale"] as float;

			model.override_material_index = model_data["material_override"] as int;
			model.set_material(null);

			#Create interaction area using the model's overall AABB
			model.model_interactable = model_data["model_interactable"] as bool;
			model.update_interaction_area();

			manager_imported_models.add_model(model);
			print("imported model loaded");
		else :
			print("model loading error");
	else :
		print("model not found");



func load_drawn_model(model_data : Dictionary) -> Model3D :
	var drawn_model : Model3D = Model3D.new();
	var primitive_mesh : Mesh = null;

	match (model_data["model_filename"] as String) :
		"Box" :
			drawn_model.model_filename = "Box";
			drawn_model.inspector_name = "Box";
			primitive_mesh = CubeMesh.new();
			(primitive_mesh as CubeMesh).size = model_data["size"] as Vector3;
		"Cube" :
			drawn_model.model_filename = "Cube";
			drawn_model.inspector_name = "Cube";
			primitive_mesh = CubeMesh.new();
			(primitive_mesh as CubeMesh).size = model_data["size"] as Vector3;
		"Sphere" :
			drawn_model.model_filename = "Sphere";
			drawn_model.inspector_name = "Sphere";
			primitive_mesh = SphereMesh.new();
			(primitive_mesh  as SphereMesh).height = (model_data["size"] as Vector3).x;
			(primitive_mesh as SphereMesh).radius = (model_data["size"] as Vector3).y;
			(primitive_mesh as SphereMesh).radial_segments = 32;
			(primitive_mesh as SphereMesh).rings = 16;
		"Cylinder" :
			drawn_model.model_filename = "Cylinder";
			drawn_model.inspector_name = "Cylinder";
			primitive_mesh = CylinderMesh.new();
			(primitive_mesh as CylinderMesh).top_radius = (model_data["size"] as Vector3).x;
			(primitive_mesh as CylinderMesh).height =(model_data["size"] as Vector3).y;
			(primitive_mesh as CylinderMesh).bottom_radius = (model_data["size"] as Vector3).z;
			(primitive_mesh as CylinderMesh).radial_segments = 16;
			(primitive_mesh as CylinderMesh).rings = 0;
		"Cone" :
			drawn_model.model_filename = "Cone";
			drawn_model.inspector_name = "Cone";
			primitive_mesh = CylinderMesh.new();
			(primitive_mesh as CylinderMesh).top_radius = 0.0;
			(primitive_mesh as CylinderMesh).height =(model_data["size"] as Vector3).y;
			(primitive_mesh as CylinderMesh).bottom_radius = (model_data["size"] as Vector3).z;
			(primitive_mesh as CylinderMesh).radial_segments = 16;
			(primitive_mesh as CylinderMesh).rings = 0;
		_ :
			pass;

	drawn_model.add_mesh(primitive_mesh);

	drawn_model.is_imported = false;

	scene_drawn_models.add_child(drawn_model);
	
	drawn_model.inspector_unfolded = model_data["inspector_unfolded"] as bool;

	drawn_model.global_transform.origin = model_data["position"] as Vector3;
	drawn_model.rotation_degrees = model_data["rotation"] as Vector3;
	drawn_model.scale = Vector3.ONE * model_data["scale"] as float;

	drawn_model.override_material_index = model_data["material_override"] as int;
	drawn_model.set_material(null);

	drawn_model.model_interactable = model_data["model_interactable"] as bool;
	drawn_model.update_interaction_area();

	manager_drawn_models.add_model(drawn_model);
	print("drawn model loaded");

	return drawn_model;

func load_note(note_data : Dictionary) -> Note3D :
	var note : Note3D = load("res://scenes/sketch_tools/note_tool/Note3D.tscn").instance();

	note.show_arrow_top_left = note_data["show_arrow_top_left"] as bool;
	note.show_arrow_top = note_data["show_arrow_top"] as bool;
	note.show_arrow_top_right = note_data["show_arrow_top_right"] as bool;
	note.show_arrow_left = note_data["show_arrow_left"] as bool;
	note.show_arrow_right = note_data["show_arrow_right"] as bool;
	note.show_arrow_bottom_left = note_data["show_arrow_bottom_left"] as bool;
	note.show_arrow_bottom = note_data["show_arrow_bottom"] as bool;
	note.show_arrow_bottom_right = note_data["show_arrow_bottom_right"] as bool;

	scene_notes.add_child(note);

	note.inspector_unfolded = note_data["inspector_unfolded"] as bool;

	note.global_transform.origin = note_data["position"] as Vector3;
	note.rotation_degrees = note_data["rotation"] as Vector3;
	note.scale = Vector3.ONE * note_data["scale"] as float;

	note.note_interactable = note_data["note_interactable"] as bool;
	note.update_interaction_area();

	note.set_inspector_name(note_data["note_name"]);
	note.set_text(note_data["note_text"]);

	manager_notes.add_note(note);

	print("note loaded");
	return note;

func save_project() -> void :
	Project.save_project();

