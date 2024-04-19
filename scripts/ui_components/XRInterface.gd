extends Area
class_name XRInterface

export(int) var pixel_per_world_unit : int = 1024.0;
export(bool) var backface_culling : bool = true;

var interface : Control = null;

var viewport : Viewport = null;

var render_target : MeshInstance = null;

var mouse_position : Vector2 = Vector2.ZERO;

var collision_shape : CollisionShape = null;

func _ready() -> void :
	for c in get_children() :
		if c is Control :
			interface = c as Control;

	if interface != null :
		remove_child(interface);

		viewport = Viewport.new();
		viewport.size = interface.rect_size;
		viewport.render_target_v_flip = true;
		viewport.transparent_bg = true;
		viewport.own_world = true;
		viewport.handle_input_locally = true;
		viewport.keep_3d_linear = true;
		add_child(viewport);
		viewport.add_child(interface);
		viewport.name = "Viewport";

		render_target = MeshInstance.new();
		render_target.mesh = QuadMesh.new();
		(render_target.mesh as QuadMesh).size = viewport.size / pixel_per_world_unit;
		
		var render_target_collider : CollisionShape = CollisionShape.new();
		render_target_collider.shape = BoxShape.new();
		(render_target_collider.shape as BoxShape).extents = Vector3(viewport.size.x / (2.0 * pixel_per_world_unit), viewport.size.y / (2.0 * pixel_per_world_unit), 0.01);
		collision_shape = render_target_collider;
		add_child(render_target_collider);

		add_child(render_target);

		var render_material : SpatialMaterial = SpatialMaterial.new();
		render_material.albedo_texture = viewport.get_texture();
		render_material.flags_unshaded = true;
		render_material.flags_transparent = true;
		if backface_culling == true :
			render_material.params_cull_mode = SpatialMaterial.CULL_BACK;
		else :
			render_material.params_cull_mode = SpatialMaterial.CULL_DISABLED;
		
		render_material.set_render_priority(127);
		render_target.set_surface_material(0, render_material);

func interface_set_mouse_position_from_world_position(world_position : Vector3) -> void :
	var mouse_position_3d : Vector3 = global_transform.affine_inverse() * world_position;
	
	var previous_mouse_position : Vector2 = mouse_position;

	mouse_position = Vector2(mouse_position_3d.x, -mouse_position_3d.y) + (render_target.mesh as QuadMesh).size / 2.0;
	mouse_position = mouse_position / (render_target.mesh as QuadMesh).size;
	mouse_position = mouse_position * viewport.size;

	var event : InputEventMouseMotion = InputEventMouseMotion.new();
	event.position = mouse_position;
	event.relative = mouse_position - previous_mouse_position;
	event.speed = mouse_position - previous_mouse_position;

	viewport.input(event);

func interface_send_mouse_click(button_index : int = BUTTON_LEFT) -> void :
	interface_send_mouse_button_pressed(button_index);
	call_deferred("interface_send_mouse_button_released", button_index);

func interface_send_mouse_button_pressed(button_index : int = BUTTON_LEFT, double_click : bool = false) -> void :
	var event : InputEventMouseButton = InputEventMouseButton.new();
	event.button_index = button_index;
	event.pressed = true;
	event.position = mouse_position;
	event.doubleclick = double_click;
	viewport.input(event);

func interface_send_mouse_button_released(button_index : int = BUTTON_LEFT) -> void :
	var event : InputEventMouseButton = InputEventMouseButton.new();
	event.button_index = button_index;
	event.pressed = false;
	event.position = mouse_position; 
	viewport.input(event);

func show_interface(value : bool) -> void :
	visible = value;
	monitorable = value;
	monitoring = value;
	collision_shape.disabled = !value;

func toggle_interface() -> void :
	var value : bool = visible;
	visible = !value;
	monitorable = !value;
	monitoring = !value;
	collision_shape.disabled = value

func parse_input_event(input_event : InputEvent) -> void :
	if viewport != null :
		viewport.input(input_event);
