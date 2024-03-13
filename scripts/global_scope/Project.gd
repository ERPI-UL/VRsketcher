extends Node

const APPDATA_PATH = "user://userdata.dat";
const MASTER_PROJECT_FILE_NAME = "projectdata.vrsk";

const IMPORT_PATH_MODELS : String = "imported_models";

var application_data : Dictionary = {
	"recent_projects" : []
};


var current_project : Dictionary = {};

signal open_project();
signal recent_projects_list_updated();

func _ready() -> void :
	load_application_data();
	
func new_project(project_name : String, project_path : String) -> void :
	var full_project_path : String = project_path + "/" + project_name;
	
	
	if DirAccess.dir_exists_absolute(full_project_path) == false:
		DirAccess.make_dir_absolute(full_project_path);
		DirAccess.make_dir_recursive_absolute(full_project_path + "/" + IMPORT_PATH_MODELS);
		
		var project_data_file = FileAccess.open(full_project_path + "/" + MASTER_PROJECT_FILE_NAME, FileAccess.WRITE);
		project_data_file.store_string(JSON.new().stringify(
			{
				"project_name"			: project_name,
				"project_path"			: full_project_path,
				"hdri_index"			: 0,
				"current_exposure"		: 1.0,
				"scene_models_data"		: [],
				"scene_line_drawings"	: [],
				"tool_shortcut_up"		: "TOOL_NONE",
				"tool_shortcut_down"	: "TOOL_NONE",
				"tool_shortcut_left"	: "TOOL_NONE",
				"tool_shortcut_right"	: "TOOL_NONE",
			}
		));
		project_data_file.close();
		
		application_data["recent_projects"].insert(
			0,
			{
				"project_name" : project_name,
				"project_path" : full_project_path,
			}
		);
		save_application_data();
		load_application_data();

func save_project() -> void :
	await get_tree().idle_frame;
	var scene_imported_models_data : Array = [];
	for model in (get_tree().root.get_node("VRSketcher") as VRSketcher).manager_imported_models.models :
		if model != null :
			scene_imported_models_data.append(
				{
					"model_filename"		: (model as Model3D).model_filename,
					"inspector_unfolded"	: (model as Model3D).inspector_unfolded,
					"position"				: (model as Model3D).global_transform.origin,
					"rotation"				: (model as Model3D).rotation_degrees,
					"scale"					: (model as Model3D).scale.x,
					"model_interactable"	: (model as Model3D).model_interactable,
					"material_override"		: (model as Model3D).override_material_index,
					"smooth_shading"		: (model as Model3D).smooth_shading
				}
			);
	current_project["scene_imported_models_data"] = scene_imported_models_data;
	
	
	var scene_drawn_models_data : Array = [];
	for model in (get_tree().root.get_node("VRSketcher") as VRSketcher).manager_drawn_models.models :
		if model != null :
			var model_size : Vector3 = Vector3.ZERO;
			match (model as Model3D).model_filename :
				"Box" :
					model_size = ((model as Model3D).meshes[0] as BoxMesh).size;
				"Cube" :
					model_size = ((model as Model3D).meshes[0] as BoxMesh).size;
				"Sphere" :
					model_size.x = ((model as Model3D).meshes[0] as SphereMesh).height;
					model_size.y = ((model as Model3D).meshes[0] as SphereMesh).radius;
				"Cylinder" :
					model_size.x = ((model as Model3D).meshes[0] as CylinderMesh).top_radius;
					model_size.y = ((model as Model3D).meshes[0] as CylinderMesh).height;
					model_size.z = ((model as Model3D).meshes[0] as CylinderMesh).bottom_radius;
				"Cone" :
					model_size.x = 0.0;
					model_size.y = ((model as Model3D).meshes[0] as CylinderMesh).height;
					model_size.z = ((model as Model3D).meshes[0] as CylinderMesh).bottom_radius;
				_ :
					pass;

			scene_drawn_models_data.append(
				{
					"model_filename"		: (model as Model3D).model_filename,
					"inspector_unfolded"	: (model as Model3D).inspector_unfolded,
					"position"				: (model as Model3D).global_transform.origin,
					"rotation"				: (model as Model3D).rotation_degrees,
					"scale"					: (model as Model3D).scale.x,
					"size"					: model_size,
					"model_interactable"	: (model as Model3D).model_interactable,
					"material_override"		: (model as Model3D).override_material_index,
					"smooth_shading"		: (model as Model3D).smooth_shading
				}
			);
	current_project["scene_drawn_models_data"] = scene_drawn_models_data;


	var scene_notes_data : Array = [];
	for note in (get_tree().root.get_node("VRSketcher") as VRSketcher).manager_notes.notes :
		if note != null :
			scene_notes_data.append(
				{
					"inspector_unfolded"		: (note as Note3D).inspector_unfolded,
					"position"					: (note as Note3D).global_transform.origin,
					"rotation"					: (note as Note3D).rotation_degrees,
					"scale"						: (note as Note3D).scale.x,
					"note_interactable"			: (note as Note3D).note_interactable,
					"note_name"					: (note as Note3D).inspector_name,
					"note_text"					: (note as Note3D).note_text,

					"show_arrow_top_left"		: (note as Note3D).show_arrow_top_left,
					"show_arrow_top"			: (note as Note3D).show_arrow_top,
					"show_arrow_top_right"		: (note as Note3D).show_arrow_top_right,
					"show_arrow_left"			: (note as Note3D).show_arrow_left,
					"show_arrow_right"			: (note as Note3D).show_arrow_right,
					"show_arrow_bottom_left"	: (note as Note3D).show_arrow_bottom_left,
					"show_arrow_bottom"			: (note as Note3D).show_arrow_bottom,
					"show_arrow_bottom_right"	: (note as Note3D).show_arrow_bottom_right,
				}
			);

	current_project["scene_notes_data"] = scene_notes_data;


	var scene_line_drawings : Array = [];
	for line in (get_tree().root.get_node("VRSketcher") as VRSketcher).scene_lines.get_children() :
		scene_line_drawings.append(
			{
				"points"			: (line as Line).points,
				"thickness"			: (line as Line).thickness,
				"material_index"	: (line as Line).material_index
			}
		);
	current_project["scene_line_drawings"] = scene_line_drawings;

	var scene_measurements : Array = [];
	for measurement in (get_tree().root.get_node("VRSketcher") as VRSketcher).scene_measurements.get_children() :
		scene_measurements.append(
			{
				"mode"				: (measurement as Measurement).mode,
				"start_point"		: (measurement as Measurement).start_point,
				"middle_point"		: (measurement as Measurement).middle_point,
				"end_point"			: (measurement as Measurement).end_point
			}
		);
	current_project["scene_measurements"] = scene_measurements;

	var full_project_path : String = current_project["project_path"];
	
	#var project_data_file : File = File.new();
	if FileAccess.file_exists(full_project_path + "/" + MASTER_PROJECT_FILE_NAME) == true :
		
		var project_data_file = FileAccess.open(full_project_path + "/" + MASTER_PROJECT_FILE_NAME, FileAccess.WRITE);

		var project_data : Dictionary = {
				"project_name"					: current_project["project_name"],
				"project_path"					: current_project["project_path"],
				"hdri_index"					: (get_tree().root.get_node("VRSketcher") as VRSketcher).hdri_manager.current_hdri_index,
				"current_exposure"				: (get_tree().root.get_node("VRSketcher") as VRSketcher).hdri_manager.current_exposure,
				"scene_imported_models_data"	: current_project["scene_imported_models_data"],
				"scene_drawn_models_data"		: current_project["scene_drawn_models_data"],
				"scene_notes_data"				: current_project["scene_notes_data"],
				"scene_line_drawings"			: current_project["scene_line_drawings"],
				"scene_measurements"			: current_project["scene_measurements"],
				"tool_shortcut_up"				: current_project["tool_shortcut_up"],
				"tool_shortcut_down"			: current_project["tool_shortcut_down"],
				"tool_shortcut_left"			: current_project["tool_shortcut_left"],
				"tool_shortcut_right"			: current_project["tool_shortcut_right"],
			}

		project_data_file.store_string(JSON.new().stringify(project_data));
		project_data_file.close();
		
		print(project_data)

func load_project(index : int) -> void :
	print("load project " + str(index))
	current_project = (application_data["recent_projects"] as Array)[index];
	
	var target_project : Dictionary = (application_data["recent_projects"] as Array)[index];

	var full_project_path : String = target_project["project_path"];
	
	#var project_data_file : File = File.new();
	if FileAccess.file_exists(full_project_path + "/" + MASTER_PROJECT_FILE_NAME) == true :
		if FileAccess.open(full_project_path + "/" + MASTER_PROJECT_FILE_NAME, FileAccess.READ) :
			var project_data_file = FileAccess.open(full_project_path + "/" + MASTER_PROJECT_FILE_NAME, FileAccess.READ)
			var test_json_conv = JSON.new()
			test_json_conv.parse(project_data_file.get_as_text());
			var parse_result : JSON = test_json_conv.get_data()
			if parse_result.error == OK :
				current_project = parse_result.result;

				if current_project.has("hdri_index" ) == true :
					(get_tree().root.get_node("VRSketcher") as VRSketcher).hdri_manager.set_environement_hdri(current_project["hdri_index"]);

				if current_project.has("current_exposure" ) == true :
					(get_tree().root.get_node("VRSketcher") as VRSketcher).hdri_manager.current_exposure = current_project["current_exposure"];

				if current_project.has("scene_imported_models_data") == true :
					for model_data in current_project["scene_imported_models_data"] :
						if model_data.has("inspector_unfolded") == true :
							model_data["inspector_unfolded"] = bool(model_data["inspector_unfolded"]);
						else :
							model_data["inspector_unfolded"] = true;

						if model_data.has("position") == true :
							model_data["position"] = parse_Vector3_from_String(model_data["position"]);
						else :
							model_data["position"] = Vector3.ZERO;

						if model_data.has("rotation") == true :
							model_data["rotation"] = parse_Vector3_from_String(model_data["rotation"]);
						else :
							model_data["rotation"] = Vector3.ZERO;

						if model_data.has("scale") == true :
							model_data["scale"] = float(model_data["scale"]);
						else :
							model_data["scale"] = 1.0;

						if model_data.has("model_interactable") == true :
							model_data["model_interactable"] = bool(model_data["model_interactable"]);
						else :
							model_data["model_interactable"] = true;

						if model_data.has("material_override") == true :
							model_data["material_override"] = int(model_data["material_override"]);
						else :
							model_data["material_override"] = -1;

						if model_data.has("smooth_shading") == true :
							model_data["smooth_shading"] = bool(model_data["smooth_shading"]);
						else :
							model_data["smooth_shading"] = false;
				else :
					current_project["scene_imported_models_data"] = [];


				if current_project.has("scene_drawn_models_data") == true :
					for model_data in current_project["scene_drawn_models_data"] :
						if model_data.has("inspector_unfolded") == true :
							model_data["inspector_unfolded"] = bool(model_data["inspector_unfolded"]);
						else :
							model_data["inspector_unfolded"] = true;

						if model_data.has("position") == true :
							model_data["position"] = parse_Vector3_from_String(model_data["position"]);
						else :
							model_data["position"] = Vector3.ZERO;

						if model_data.has("rotation") == true :
							model_data["rotation"] = parse_Vector3_from_String(model_data["rotation"]);
						else :
							model_data["rotation"] = Vector3.ZERO;

						if model_data.has("scale") == true :
							model_data["scale"] = float(model_data["scale"]);
						else :
							model_data["scale"] = 1.0;

						if model_data.has("model_interactable") == true :
							model_data["model_interactable"] = bool(model_data["model_interactable"]);
						else :
							model_data["model_interactable"] = true;

						if model_data.has("material_override") == true :
							model_data["material_override"] = int(model_data["material_override"]);
						else :
							model_data["material_override"] = -1;

						if model_data.has("smooth_shading") == true :
							model_data["smooth_shading"] = bool(model_data["smooth_shading"]);
						else :
							model_data["smooth_shading"] = false;

						if model_data.has("size") == true :
							model_data["size"] = parse_Vector3_from_String(model_data["size"]);
						else :
							model_data["size"] = Vector3.ONE;
				else :
					current_project["scene_drawn_models_data"] = [];


				if current_project.has("scene_notes_data") == true :
					for note_data in current_project["scene_notes_data"] :
						if note_data.has("inspector_unfolded") == true :
							note_data["inspector_unfolded"] = bool(note_data["inspector_unfolded"]);
						else :
							note_data["inspector_unfolded"] = true;

						if note_data.has("position") == true :
							note_data["position"] = parse_Vector3_from_String(note_data["position"]);
						else :
							note_data["position"] = Vector3.ZERO;

						if note_data.has("rotation") == true :
							note_data["rotation"] = parse_Vector3_from_String(note_data["rotation"]);
						else :
							note_data["rotation"] = Vector3.ZERO;

						if note_data.has("scale") == true :
							note_data["scale"] = float(note_data["scale"]);
						else :
							note_data["scale"] = 1.0;

						if note_data.has("note_name") == true :
							note_data["note_name"] = note_data["note_name"];
						else :
							note_data["note_name"] = "";

						if note_data.has("note_text") == true :
							note_data["note_text"] = note_data["note_text"];
						else :
							note_data["note_text"] = "";
							

						if note_data.has("note_interactable") == true :
							note_data["note_interactable"] = bool(note_data["note_interactable"]);
						else :
							note_data["note_interactable"] = true;

						if note_data.has("show_arrow_top") == true :
							note_data["show_arrow_top"] = bool(note_data["show_arrow_top"]);
						else :
							note_data["show_arrow_top"] = true;

						if note_data.has("show_arrow_bottom") == true :
							note_data["show_arrow_bottom"] = bool(note_data["show_arrow_bottom"]);
						else :
							note_data["show_arrow_bottom"] = true;

						if note_data.has("show_arrow_left") == true :
							note_data["show_arrow_left"] = bool(note_data["show_arrow_left"]);
						else :
							note_data["show_arrow_left"] = true;

						if note_data.has("show_arrow_right") == true :
							note_data["show_arrow_right"] = bool(note_data["show_arrow_right"]);
						else :
							note_data["show_arrow_right"] = true;

						if note_data.has("show_arrow_top_left") == true :
							note_data["show_arrow_top_left"] = bool(note_data["show_arrow_top_left"]);
						else :
							note_data["show_arrow_top_left"] = true;
							
						if note_data.has("show_arrow_top_right") == true :
							note_data["show_arrow_top_right"] = bool(note_data["show_arrow_top_right"]);
						else :
							note_data["show_arrow_top_right"] = true;

						if note_data.has("show_arrow_bottom_left") == true :
							note_data["show_arrow_bottom_left"] = bool(note_data["show_arrow_bottom_left"]);
						else :
							note_data["show_arrow_bottom_left"] = true;

						if note_data.has("show_arrow_bottom_right") == true :
							note_data["show_arrow_bottom_right"] = bool(note_data["show_arrow_bottom_right"]);
						else :
							note_data["show_arrow_bottom_right"] = true;
				else :
					current_project["scene_drawn_models_data"] = [];

				if current_project.has("scene_line_drawings") == true :
					for line_data in current_project["scene_line_drawings"] :
						var points_array : Array = []
						for point in line_data["points"] :
							points_array.append(parse_Vector3_from_String(point));
						line_data["points"] = points_array;
						line_data["thickness"] = float(line_data["thickness"]);
						line_data["material_index"] = int(line_data["material_index"]);
				else :
					current_project["scene_line_drawings"] = [];


				if current_project.has("scene_measurements") == true :
					for measurement_data in current_project["scene_measurements"] :
						measurement_data["mode"] = int(measurement_data["mode"]);
						measurement_data["start_point"] = parse_Vector3_from_String(measurement_data["start_point"]);
						measurement_data["middle_point"] = parse_Vector3_from_String(measurement_data["middle_point"]);
						measurement_data["end_point"] = parse_Vector3_from_String(measurement_data["end_point"]);
				else :
					current_project["scene_measurements"] = [];

				if current_project.has("tool_shortcut_up") == false :
					current_project["tool_shortcut_up"] = "TOOL_NONE";
				if current_project.has("tool_shortcut_down") == false :
					current_project["tool_shortcut_down"] = "TOOL_NONE";
				if current_project.has("tool_shortcut_left") == false :
					current_project["tool_shortcut_left"] = "TOOL_NONE";
				if current_project.has("tool_shortcut_right") == false :
					current_project["tool_shortcut_right"] = "TOOL_NONE";

			print(current_project);

			project_data_file.close();
			
	emit_signal("open_project");

func import_project(path : String) -> void :
	print("import VRSketcher project at : " + path);
	var imported_project_name : String = path.rsplit("/", true, 2)[1];
	var imported_project_path : String = path.rsplit("/", true, 1)[0];

	#Update project's name and path in projectdata.vrsk file
	var project_data : Dictionary = {};
	#var file : File = File.new();
	if FileAccess.open(path, FileAccess.READ) :
		var test_json_conv = JSON.new()
		var file = FileAccess.open(path, FileAccess.READ);
		test_json_conv.parse(file.get_as_text());
		var parse_result : JSON = test_json_conv.get_data()
		if parse_result.error == OK :
			project_data = parse_result.result;
			
			project_data["project_name"] = imported_project_name;
			project_data["project_path"] = imported_project_path;

			file.close();

			if file.open(path, FileAccess.WRITE) :
				file.store_string(JSON.new().stringify(project_data));
				file.close();
			else :
				print("Error while importing project");
				return;

			#Add imported project to the current recent projects list
			(application_data["recent_projects"] as Array).insert(
				0,
				{
					"project_name"	:	imported_project_name,
					"project_path"	:	imported_project_path
				}
			);

			save_application_data();
			load_application_data();
		else :
			print("Error while importing project");
			return;
	else :
		print("Error while importing project");
		return;

func save_application_data() -> void :
	print(application_data)
	
	#var file : FileAccess = File.new();
	var file = FileAccess.open(APPDATA_PATH, FileAccess.WRITE);
	file.store_string(JSON.new().stringify(application_data));
	file.close();

func load_application_data() -> void :
	#var file : File = File.new();
	if FileAccess.file_exists(APPDATA_PATH) == false :
		save_application_data();

	#Recent projects list
	if FileAccess.open(APPDATA_PATH, FileAccess.READ) :
		var test_json_conv = JSON.new()
		var file = FileAccess.open(APPDATA_PATH, FileAccess.READ)
		test_json_conv.parse(file.get_as_text());
		var parse_result : JSON = test_json_conv.get_data()
		if parse_result.error == OK :
			application_data["recent_projects"] = parse_result.result["recent_projects"]

	#Remove missing projects from the list
	var found_projects : Array = [];
	for project in application_data["recent_projects"] :
		var project_path : String = (project as Dictionary)["project_path"] as String;
		#var project_file : File = File.new();
		
		print(project_path + "/" + MASTER_PROJECT_FILE_NAME)
		
		if FileAccess.file_exists(project_path + "/" + MASTER_PROJECT_FILE_NAME) == true :
			found_projects.append(project);

	application_data["recent_projects"] = found_projects;
	
	emit_signal("recent_projects_list_updated");

	save_application_data();

func get_imported_models_directory_path() -> String :
	return current_project["project_path"] + "/" + IMPORT_PATH_MODELS;

func parse_Vector3_from_String (from : String) -> Vector3 :
	var to = from;
	to = (to as String).replace('(', '');
	to = (to as String).replace(')', '');
	to = (to as String).replace(' ', '');
	to = (to as String).split_floats(',', false);
	return Vector3(to[0] as float, to[1] as float, to[2] as float);
