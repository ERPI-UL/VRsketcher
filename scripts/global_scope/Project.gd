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
	
	var dir : Directory = Directory.new();
	
	if dir.dir_exists(full_project_path) == false :
		dir.make_dir(full_project_path);
		dir.make_dir_recursive(full_project_path + "/" + IMPORT_PATH_MODELS);
			
		var project_data_file : File = File.new();
		project_data_file.open(full_project_path + "/" + MASTER_PROJECT_FILE_NAME, File.WRITE);

		project_data_file.store_string(to_json(
			{
				"project_name" : project_name,
				"project_path" : full_project_path,
				"hdri_index" : 0,
				"current_exposure" : 1.0,
				"scene_models_data" : [],
				"scene_line_drawings" : []
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
	yield(get_tree(), "idle_frame");
	var scene_imported_models_data : Array = [];
	for model in (get_tree().root.get_node("VRSketcher") as VRSketcher).manager_imported_models.models :
		if model != null :
			scene_imported_models_data.append(
				{
					"model_filename" : (model as Model3D).model_filename,
					"inspector_unfolded" : (model as Model3D).inspector_unfolded,
					"position" : (model as Model3D).global_transform.origin,
					"rotation" : (model as Model3D).rotation_degrees,
					"scale" : (model as Model3D).scale.x,
					"material_override" : (model as Model3D).override_material_index
				}
			);
	current_project["scene_imported_models_data"] = scene_imported_models_data;
	
	
	var scene_drawn_models_data : Array = [];
	for model in (get_tree().root.get_node("VRSketcher") as VRSketcher).manager_drawn_models.models :
		if model != null :
			var model_size : Vector3 = Vector3.ZERO;
			match (model as Model3D).model_filename :
				"Box" :
					model_size = ((model as Model3D).meshes[0] as CubeMesh).size;
				"Cube" :
					model_size = ((model as Model3D).meshes[0] as CubeMesh).size;
				"Sphere" :
					model_size.x = ((model as Model3D).meshes[0] as SphereMesh).height;
					model_size.y = ((model as Model3D).meshes[0] as SphereMesh).radius;
				_ :
					pass;

			scene_drawn_models_data.append(
				{
					"model_filename" : (model as Model3D).model_filename,
					"inspector_unfolded" : (model as Model3D).inspector_unfolded,
					"position" : (model as Model3D).global_transform.origin,
					"rotation" : (model as Model3D).rotation_degrees,
					"scale" : (model as Model3D).scale.x,
					"size" : model_size,
					"material_override" : (model as Model3D).override_material_index
				}
			);
	current_project["scene_drawn_models_data"] = scene_drawn_models_data;

	var scene_line_drawings : Array = [];
	for line in (get_tree().root.get_node("VRSketcher") as VRSketcher).scene_lines.get_children() :
		scene_line_drawings.append(
			{
				"points" : (line as Line).points,
				"thickness" : (line as Line).thickness,
				"material_index" : (line as Line).material_index
			}
		);
	current_project["scene_line_drawings"] = scene_line_drawings;

	var scene_measurements : Array = [];
	for measurement in (get_tree().root.get_node("VRSketcher") as VRSketcher).scene_measurements.get_children() :
		scene_measurements.append(
			{
				"mode" : (measurement as Measurement).mode,
				"start_point" : (measurement as Measurement).start_point,
				"middle_point" : (measurement as Measurement).middle_point,
				"end_point" : (measurement as Measurement).end_point
			}
		);
	current_project["scene_measurements"] = scene_measurements;

	var full_project_path : String = current_project["project_path"];
	
	var project_data_file : File = File.new();
	if project_data_file.file_exists(full_project_path + "/" + MASTER_PROJECT_FILE_NAME) == true :
		
		project_data_file.open(full_project_path + "/" + MASTER_PROJECT_FILE_NAME, File.WRITE);

		var project_data : Dictionary = {
				"project_name" : current_project["project_name"],
				"project_path" : current_project["project_path"],
				"hdri_index" : (get_tree().root.get_node("VRSketcher") as VRSketcher).hdri_manager.current_hdri_index,
				"current_exposure" : (get_tree().root.get_node("VRSketcher") as VRSketcher).hdri_manager.current_exposure,
				"scene_imported_models_data" : current_project["scene_imported_models_data"],
				"scene_drawn_models_data" : current_project["scene_drawn_models_data"],
				"scene_line_drawings" : current_project["scene_line_drawings"],
				"scene_measurements" : current_project["scene_measurements"]
			}

		project_data_file.store_string(to_json(project_data));
		project_data_file.close();
		
		print(project_data)

func load_project(index : int) -> void :
	print("load project " + str(index))
	current_project = (application_data["recent_projects"] as Array)[index];
	
	var target_project : Dictionary = (application_data["recent_projects"] as Array)[index];

	var full_project_path : String = target_project["project_path"];
	
	var project_data_file : File = File.new();
	if project_data_file.file_exists(full_project_path + "/" + MASTER_PROJECT_FILE_NAME) == true :
		if project_data_file.open(full_project_path + "/" + MASTER_PROJECT_FILE_NAME, File.READ) == OK :
			var parse_result : JSONParseResult = JSON.parse(project_data_file.get_as_text());
			if parse_result.error == OK :
				current_project = parse_result.result;

				if current_project.has("hdri_index" ) == true :
					(get_tree().root.get_node("VRSketcher") as VRSketcher).hdri_manager.set_environement_hdri(current_project["hdri_index"]);

				if current_project.has("current_exposure" ) == true :
					(get_tree().root.get_node("VRSketcher") as VRSketcher).hdri_manager.current_exposure = current_project["current_exposure"];

				if current_project.has("scene_imported_models_data") == true :
					for model_data in current_project["scene_imported_models_data"] :
						model_data["inspector_unfolded"] = bool(model_data["inspector_unfolded"]);
						model_data["position"] = parse_Vector3_from_String(model_data["position"]);
						model_data["rotation"] = parse_Vector3_from_String(model_data["rotation"]);
						model_data["scale"] = float(model_data["scale"]);
						model_data["material_override"] = int(model_data["material_override"]);
				else :
					current_project["scene_imported_models_data"] = [];


				if current_project.has("scene_drawn_models_data") == true :
					for model_data in current_project["scene_drawn_models_data"] :
						model_data["inspector_unfolded"] = bool(model_data["inspector_unfolded"]);
						model_data["position"] = parse_Vector3_from_String(model_data["position"]);
						model_data["rotation"] = parse_Vector3_from_String(model_data["rotation"]);
						model_data["scale"] = float(model_data["scale"]);
						model_data["size"] = parse_Vector3_from_String(model_data["size"]);
						model_data["material_override"] = int(model_data["material_override"]);
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

			print(current_project);

			project_data_file.close();
			
	emit_signal("open_project");

func import_project(path : String) -> void :
	print("import VRSketcher project at : " + path);
	var imported_project_name : String = path.rsplit("/", true, 2)[1];
	var imported_project_path : String = path.rsplit("/", true, 1)[0];

	#Update project's name and path in projectdata.vrsk file
	var project_data : Dictionary = {};
	var file : File = File.new();
	if file.open(path, File.READ_WRITE) == OK :
		var parse_result : JSONParseResult = JSON.parse(file.get_as_text());
		if parse_result.error == OK :
			project_data = parse_result.result;
			
			project_data["project_name"] = imported_project_name;
			project_data["project_path"] = imported_project_path;

			file.store_string(to_json(project_data));
		file.close();

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

func save_application_data() -> void :
	print(application_data)
	
	var file : File = File.new();
	file.open(APPDATA_PATH, File.WRITE);
	file.store_string(to_json(application_data));
	file.close();

func load_application_data() -> void :
	var file : File = File.new();
	if file.file_exists(APPDATA_PATH) == false :
		save_application_data();

	#Recent projects list
	if file.open(APPDATA_PATH, File.READ) == OK :
		var parse_result : JSONParseResult = JSON.parse(file.get_as_text());
		if parse_result.error == OK :
			application_data["recent_projects"] = parse_result.result["recent_projects"]

	#Remove missing projects from the list
	var found_projects : Array = [];
	for project in application_data["recent_projects"] :
		var project_path : String = (project as Dictionary)["project_path"] as String;
		var project_file : File = File.new();
		
		print(project_path + "/" + MASTER_PROJECT_FILE_NAME)
		
		if project_file.file_exists(project_path + "/" + MASTER_PROJECT_FILE_NAME) == true :
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
