@tool
extends SubViewport

var render_list : Array = [
	["city 01", "res://assets/hdri/city 01.hdr"],
	["city 02", "res://assets/hdri/city 02.hdr"],
	["city 03", "res://assets/hdri/city 03.hdr"],
	["city 04", "res://assets/hdri/city 04.hdr"],
	["city 05", "res://assets/hdri/city 05.hdr"],
	["city 06", "res://assets/hdri/city 06.hdr"],
	["city 07", "res://assets/hdri/city 07.hdr"],
	
	["forest 01", "res://assets/hdri/forest 01.hdr"],
	
	["interior 01", "res://assets/hdri/interior 01.hdr"],
	["interior 02", "res://assets/hdri/interior 02.hdr"],
	["interior 03", "res://assets/hdri/interior 03.hdr"],
	["interior 04", "res://assets/hdri/interior 04.hdr"],
	["interior 05", "res://assets/hdri/interior 05.hdr"],
	["interior 06", "res://assets/hdri/interior 06.hdr"],
	["interior 07", "res://assets/hdri/interior 07.hdr"],
	
	["outdoor 01", "res://assets/hdri/outdoor 01.hdr"],
	["outdoor 02", "res://assets/hdri/outdoor 02.hdr"],
	["outdoor 03", "res://assets/hdri/outdoor 03.hdr"],
	
	["sky 01", "res://assets/hdri/sky 01.hdr"],
	["sky 02", "res://assets/hdri/sky 02.hdr"],
	["sky 03", "res://assets/hdri/sky 03.hdr"],
	
	["studio 01", "res://assets/hdri/studio 01.hdr"],
	
	["alien 01", "res://assets/hdri/alien_01.hdr"],
	["alien 02", "res://assets/hdri/alien_02.hdr"]
];

var render_path : String = "res://assets/hdri/icons/";

@export var render: bool = false;

@onready var render_mesh : Node3D = get_node("Node3D/MeshInstance3D");


func _process(_delta : float) -> void :
	if render == true :
		render = false;
		
		var mat : StandardMaterial3D = render_mesh.get_surface_override_material(0);
		
		for i in range(0, render_list.size()) :
			mat.albedo_texture = load(render_list[i][1]);
	
			RenderingServer.force_draw();
			var img : Image = (get_texture() as ViewportTexture).get_data();
			img.save_png(render_path + render_list[i][0] + ".png");
