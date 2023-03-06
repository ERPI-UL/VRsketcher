extends Node
class_name Exporter_OBJ

func get_file_extension() -> String :
	return "obj";

func export_geometry(mesh : ArrayMesh, export_path : String) -> bool :
	return false;
