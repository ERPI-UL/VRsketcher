extends Node
class_name Exporter_3MF

func get_file_extension() -> String :
	return "3mf";

func export_geometry(mesh : ArrayMesh, export_path : String) -> bool :
	return false;
