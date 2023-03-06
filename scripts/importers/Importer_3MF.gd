extends Importer

func import_model_file(path : String) -> Array :
	var meshes : Array = [];
	var file_unit : String = "meter";

	var current_mesh_data : Dictionary = {};

	var parser : XMLParser = XMLParser.new();

	var error = parser.open(path);
	if error != OK :
		print(error);
		return [];
	else :
		while parser.read() == OK :

			if parser.get_node_type() == XMLParser.NODE_ELEMENT  :

				var node_name : String = parser.get_node_name();
				
				if node_name == "mesh" :
					current_mesh_data = {
						"vertices"	: [],
						"triangles"	: []
					}
					meshes.append(current_mesh_data);
				if node_name == "model" :
					file_unit = parser.get_named_attribute_value("unit");
					print(file_unit)
				if node_name == "vertex" :
					var x : float = parser.get_named_attribute_value("x").to_float();
					var y : float = parser.get_named_attribute_value("y").to_float();
					var z : float = parser.get_named_attribute_value("z").to_float();
					
					(current_mesh_data["vertices"] as Array).append(Vector3(x, y, z));
				if node_name == "triangle" :
					var v_1 : int = parser.get_named_attribute_value("v1").to_int();
					var v_2 : int = parser.get_named_attribute_value("v2").to_int();
					var v_3 : int = parser.get_named_attribute_value("v3").to_int();
					
					(current_mesh_data["triangles"] as Array).append([v_1, v_2, v_3]);

	var output_meshes : Array = [];

	for mesh_data in meshes :
		var surface_tool : SurfaceTool = SurfaceTool.new();
		surface_tool.begin(PrimitiveMesh.PRIMITIVE_TRIANGLES);

		for i in range(0, ((mesh_data as Dictionary)["triangles"] as Array).size()) :
			var triangle : Array = ((mesh_data as Dictionary)["triangles"] as Array)[i];
			var unit_factor : float = get_unit_conversion_factor(file_unit);
			surface_tool.add_vertex(((mesh_data as Dictionary)["vertices"] as Array)[triangle[0]] / unit_factor);
			surface_tool.add_vertex(((mesh_data as Dictionary)["vertices"] as Array)[triangle[1]] / unit_factor);
			surface_tool.add_vertex(((mesh_data as Dictionary)["vertices"] as Array)[triangle[2]] / unit_factor);

		surface_tool.generate_normals();
		
		output_meshes.append(surface_tool.commit());

	return output_meshes;

func get_unit_conversion_factor(var unit : String) -> float :
	match unit :
		"meter"			: return 1.0;
		"millimeter"	: return 1000.0;
		"inch"			: return 39.37;
		_				: return 1.0;
