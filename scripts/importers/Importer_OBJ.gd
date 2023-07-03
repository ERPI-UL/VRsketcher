extends Importer

func import_model_file(path : String, smooth_shading : bool = false) -> Array :
	var meshes : Array = [];
	var file_unit : String = "meter";

	var current_mesh_data : Dictionary = {};

	var file : File = File.new();

	var error = file.open(path, File.READ);
	if error != OK :
		print(error);
		return [];
	else :
		current_mesh_data = {
			"vertices"	: [],
			"triangles"	: [],
			"uvs"		: [],
			"normals"	: []
		}
		meshes.append(current_mesh_data);

		while file.eof_reached() == false :
			var line : Array = file.get_line().split(" ", false);

			if line != null && line.size() > 0 :
				match line[0] :
					"#" :
						#Comment
						pass;
					"v" :
						#Vertex
						(current_mesh_data["vertices"] as Array).append(Vector3(line[1].to_float(), line[2].to_float(), line[3].to_float()));
					"vn" :
						#Normal
						(current_mesh_data["normals"] as Array).append(Vector3(line[1].to_float(), line[2].to_float(), line[3].to_float()));
					"vt" :
						#Texture coordinate
						(current_mesh_data["uvs"] as Array).append(Vector2(line[1].to_float(), 1.0 - line[2].to_float()));
					"f" :
						#Face
						if line.size() == 4 :
							#Triangle
							var face : Dictionary = {"vertices" : [], "uvs" : [], "normals" : []};
							
							for map in line :
								var vertex_indices : Array = map.split("/");
								if vertex_indices[0] != "f" :
									face["vertices"].append(vertex_indices[0].to_int() - 1);
									face["uvs"].append(vertex_indices[1].to_int() - 1);
									if vertex_indices.size() > 2 :
										face["normals"].append(vertex_indices[2].to_int() - 1);
							current_mesh_data["triangles"].append(face);

						elif line.size() > 4 :
							# Triangulate face
							var points: Array = [];
							for map in line :
								var vertices_index: Array = map.split("/");
								if (vertices_index[0] != "f") :
									var point: Array = [];
									point.append(vertices_index[0].to_int() - 1);
									point.append(vertices_index[1].to_int() - 1);
									if (vertices_index.size() > 2) :
										point.append(vertices_index[2].to_int()-1);
									points.append(point);
							for i in (points.size()) :
								if i != 0 :
									var face = {"vertices" : [], "uvs" : [], "normals" : []};
									var point_0 : Array = points[0];
									var point_1 : Array = points[i];
									var point_2 : Array = points[i-1];

									face["vertices"].append(point_0[0]);
									face["vertices"].append(point_2[0]);
									face["vertices"].append(point_1[0]);

									face["uvs"].append(point_0[1]);
									face["uvs"].append(point_2[1]);
									face["uvs"].append(point_1[1]);

									if (point_0.size() > 2) :
										face["normals"].append(point_0[2]);
									if (point_2.size() > 2) :
										face["normals"].append(point_2[2]);
									if (point_1.size() > 2) :
										face["normals"].append(point_1[2]);

									current_mesh_data["triangles"].append(face);

	var output_meshes : Array = [];

	for mesh_data in meshes :
		var surface_tool : SurfaceTool = SurfaceTool.new();
		surface_tool.begin(PrimitiveMesh.PRIMITIVE_TRIANGLES);
		
		if smooth_shading == true :
			surface_tool.add_smooth_group(true);

		for i in range(0, ((mesh_data as Dictionary)["triangles"] as Array).size()) :
			var triangle : Array = ((mesh_data as Dictionary)["triangles"] as Array)[i]["vertices"];

			surface_tool.add_vertex(((mesh_data as Dictionary)["vertices"] as Array)[triangle[0]]);
			surface_tool.add_vertex(((mesh_data as Dictionary)["vertices"] as Array)[triangle[1]]);
			surface_tool.add_vertex(((mesh_data as Dictionary)["vertices"] as Array)[triangle[2]]);

		surface_tool.generate_normals();

		output_meshes.append(surface_tool.commit());

	return output_meshes;
