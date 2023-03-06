extends Importer

func import_model_file(path : String) -> Array :
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
			var line : String = file.get_line();


			
			if line.begins_with("v ") == true :
				#Vertex
				var vertex_data : Array = line.split(" ");
				if vertex_data.size() >= 4 :
					var x : float = vertex_data[1].to_float();
					var y : float = vertex_data[2].to_float();
					var z : float = vertex_data[3].to_float();
					
					(current_mesh_data["vertices"] as Array).append(Vector3(x, y, z));
			if line.begins_with("vn ") == true :
				#Normal
				var normal_data : Array = line.split(" ");
				if normal_data.size() >= 4 :
					var x : float = normal_data[1].to_float();
					var y : float = normal_data[2].to_float();
					var z : float = normal_data[3].to_float();
					
					(current_mesh_data["normals"] as Array).append(Vector3(x, y, z));
					
					
			if line.begins_with("vt ") == true :
				#Texture coordinate
				var texture_coordinate : Array = line.split(" ");
				
				var u : float = 0.0;
				var v : float = 0.0;
				
				if texture_coordinate.size() >= 3 :
					u = texture_coordinate[1].to_float();
					v = texture_coordinate[2].to_float();
				elif texture_coordinate.size() >= 2 :
					u = texture_coordinate[1].to_float();
				
				(current_mesh_data["uvs"] as Array).append(Vector2(u, v));
					
					
			if line.begins_with("f ") == true :
				#Triangle
				var triangle_data : Array = line.split(" ");
				if triangle_data.size() >= 4 :
					var triangle_data_1 : Array = triangle_data[1].split("/");
					var triangle_data_2 : Array = triangle_data[2].split("/");
					var triangle_data_3 : Array = triangle_data[3].split("/");

					var v_1 : int = triangle_data_1[0].to_int() - 1;
					var v_2 : int = triangle_data_2[0].to_int() - 1;
					var v_3 : int = triangle_data_3[0].to_int() - 1;
					
					
					var t_1 : int = triangle_data[1].to_int() - 1;
					
					(current_mesh_data["triangles"] as Array).append(
						[
							[v_1],
							[v_2],
							[v_3]
						]
					);
			
			

				
				
				"""
				# Polygonal face element (see below)
				f 1 2 3
				f 3/1 4/2 5/3
				f 6/4/1 3/5/3 7/6/5
				f 7//1 8//2 9//3
				f ...
				
				
				
				
				
				
				
				
				
				
				
				"""
				

	var output_meshes : Array = [];

	for mesh_data in meshes :
		var surface_tool : SurfaceTool = SurfaceTool.new();
		surface_tool.begin(PrimitiveMesh.PRIMITIVE_TRIANGLES);

		for i in range(0, ((mesh_data as Dictionary)["triangles"] as Array).size()) :
			var triangle : Array = ((mesh_data as Dictionary)["triangles"] as Array)[i];
			surface_tool.add_vertex(((mesh_data as Dictionary)["vertices"] as Array)[triangle[0][0]]);
			surface_tool.add_vertex(((mesh_data as Dictionary)["vertices"] as Array)[triangle[1][0]]);
			surface_tool.add_vertex(((mesh_data as Dictionary)["vertices"] as Array)[triangle[2][0]]);

		surface_tool.generate_normals();
		
		output_meshes.append(surface_tool.commit());

	return output_meshes;
