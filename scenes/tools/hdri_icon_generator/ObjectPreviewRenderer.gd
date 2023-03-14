tool
extends Viewport

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
	["outdoor 01", "res://assets/hdri/outdoor 01.hdr"],
	["outdoor 02", "res://assets/hdri/outdoor 02.hdr"],
	["sky 01", "res://assets/hdri/sky 01.hdr"],
	["sky 02", "res://assets/hdri/sky 02.hdr"],
	["sky 03", "res://assets/hdri/sky 03.hdr"],
	["studio 01", "res://assets/hdri/studio 01.hdr"]
];

var render_path : String = "res://assets/hdri/icons/";

export(bool) var render : bool = false;

onready var render_mesh : Spatial = get_node("Spatial/MeshInstance");


func _process(_delta : float) -> void :
	if render == true :
		render = false;
		
		var mat : SpatialMaterial = render_mesh.get_surface_material(0);
		
		for i in range(0, render_list.size()) :
			mat.albedo_texture = load(render_list[i][1]);
	
			VisualServer.force_draw();
			var img : Image = (get_texture() as ViewportTexture).get_data();
			img.save_png(render_path + render_list[i][0] + ".png");
