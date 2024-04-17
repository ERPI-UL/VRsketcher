extends Spatial;
class_name XRInterfaceController

export(bool) var enabled : bool = false;

export(float, 0.1, 20.0) var max_ray_length : float = 10.0;

export(int, LAYERS_3D_PHYSICS) var collision_mask : int = 0x00000000;

export(Color, RGBA) var ray_color : Color = Color.cyan;
export(float) var gizmo_ray_thickness : float = 0.01;
export(float) var gizmo_end_radius : float = 0.02;

var raycast : RayCast = null;
var gizmo_ray : MeshInstance = null;
var gizmo_end : MeshInstance = null;

var interface : XRInterface = null;
var hover_state : bool = false;
var previous_hover_state : bool = false;

var controller_signal_connection_silenced : bool = true;

signal xr_interface_entered();
signal xr_interface_exited();

func _ready() -> void :
	var gizmo_material : SpatialMaterial = SpatialMaterial.new();
	gizmo_material.params_cull_mode = SpatialMaterial.CULL_BACK;
	gizmo_material.albedo_color = Color.black;
	gizmo_material.emission_enabled = true;
	gizmo_material.emission = ray_color;
	
	raycast = RayCast.new();
	raycast.cast_to = Vector3(0.0, 0.0, -max_ray_length);
	raycast.collide_with_areas = true;
	raycast.collide_with_bodies = true;
	raycast.collision_mask = collision_mask;
	raycast.exclude_parent = true;
	add_child(raycast);
	
	#Create ray gizmo meshes
	gizmo_ray = MeshInstance.new();
	gizmo_ray.material_overlay = gizmo_material;
	gizmo_ray.mesh = CylinderMesh.new();
	(gizmo_ray.mesh as CylinderMesh).height = 1.0;
	(gizmo_ray.mesh as CylinderMesh).top_radius = gizmo_ray_thickness / 2.0;
	(gizmo_ray.mesh as CylinderMesh).bottom_radius = gizmo_ray_thickness / 2.0;
	(gizmo_ray.mesh as CylinderMesh).rings = 0;
	(gizmo_ray.mesh as CylinderMesh).radial_segments = 8;
	add_child(gizmo_ray);
	gizmo_ray.rotation_degrees.x = 90.0;

	gizmo_end = MeshInstance.new();
	gizmo_end.material_overlay = gizmo_material;
	gizmo_end.mesh = SphereMesh.new();
	(gizmo_end.mesh as SphereMesh).radius = gizmo_end_radius;
	(gizmo_end.mesh as SphereMesh).height = gizmo_end_radius * 2.0;
	(gizmo_end.mesh as SphereMesh).radial_segments = 16;
	(gizmo_end.mesh as SphereMesh).rings = 8;
	add_child(gizmo_end);
	
	set_enabled(enabled);


func _physics_process(_delta : float) -> void :
	if enabled == true :
		var collision_distance : float = max_ray_length;
		
		if raycast.is_colliding() == true :
			collision_distance = raycast.global_transform.origin.distance_to(raycast.get_collision_point());

			if raycast.get_collider() is XRInterface :
				interface = raycast.get_collider();
				interface.interface_set_mouse_position_from_world_position(raycast.get_collision_point());
				hover_state = true;
			else :
				interface = null;
				hover_state = false;
		else :
			interface = null;
			hover_state = false;

		#Update gizmo
		gizmo_ray.translation.z = -collision_distance / 2.0;
		gizmo_ray.scale.y = -collision_distance;
		gizmo_end.translation.z = -collision_distance;
	else :
		interface = null;
		hover_state = false;

	#Handle xr interface hovering
	if previous_hover_state == false && hover_state == true :
		emit_signal("xr_interface_entered");
	elif previous_hover_state == true && hover_state == false :
		emit_signal("xr_interface_exited");
	previous_hover_state = hover_state;

func set_enabled(value : bool) -> void :
	enabled = value;
	raycast.enabled = value;
	gizmo_ray.visible = value;
	gizmo_end.visible = value;

func interface_send_mouse_button_pressed(button_index : int = BUTTON_LEFT) -> void :
	if interface != null :
		interface.interface_send_mouse_button_pressed(button_index);

func interface_send_mouse_button_released(button_index : int = BUTTON_LEFT) -> void :
	if interface != null :
		interface.interface_send_mouse_button_released(button_index);
