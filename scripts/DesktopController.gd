extends Controller

export(float) var walk_speed : float = 3.0;
export(float) var run_speed : float = 6.0;

export(float) var h_sensitivity : float = 150.0;
export(float) var v_sensitivity : float = 100.0;

export(Vector3) var gravity : Vector3 = Vector3(0.0, -9.81, 0.0);

export(float) var fov : float = 70.0;

onready var h_pivot : Spatial = get_node("H_Pivot");
onready var v_pivot : Spatial = get_node("H_Pivot/V_Pivot");
onready var camera : Camera = get_node("H_Pivot/V_Pivot/Camera");

func _physics_process(delta : float) -> void :
	if Input.is_action_just_pressed("ui_cancel") == true :
		print(Input.mouse_mode)
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED :
			Input.mouse_mode = 0;

		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE :
			Input.mouse_mode = 2;

	var speed : float = walk_speed;
	if Input.is_action_pressed("run") == true :
		speed = run_speed;

	var right : Vector3 = camera.global_transform.basis.x;
	var forward : Vector3 = camera.global_transform.basis.z;

	var move_input : Vector2 = get_move_input();
	var move : Vector3 = ((right * move_input.x) + (forward * move_input.y));
	move.y = 0.0;
	move = move.normalized() * speed;
	
	var vertical_movement : Vector3 = Vector3.ZERO;
	if Input.is_action_pressed("move_upwards") == true :
		vertical_movement.y += walk_speed;
	if Input.is_action_pressed("move_downwards") == true :
		vertical_movement.y -= walk_speed;
	
	move += vertical_movement
	
	if has_method("move_and_slide") == true :
		move = self.call("move_and_slide", move, Vector3.UP, true)

	var grav : Vector3 = gravity;

	if has_method("is_on_floor") == true :
		if self.call("is_on_floor") == true :
			grav = Vector3.ZERO;

	if has_method("move_and_slide") == true :
		move = self.call("move_and_slide", grav, Vector3.UP, true)

	var look_input : Vector2 = get_look_input();
	
	h_pivot.rotate_y(deg2rad(look_input.x) * -h_sensitivity * delta);
	v_pivot.rotate_x(deg2rad(look_input.y) * -v_sensitivity * delta);

	v_pivot.rotation_degrees.x = clamp(v_pivot.rotation_degrees.x, -90.0, 90.0);
	
	if Input.is_action_just_pressed("tool_use") == true :
		get_current_tool().start_tool_use();
		
	if Input.is_action_just_released("tool_use") == true :
		get_current_tool().stop_tool_use();
	
	if Input.is_action_just_pressed("tool_switch") == true :
		switch_tool();
	
	if Input.is_action_just_pressed("tool_switch_mode") == true :
		get_current_tool().switch_tool_mode();

	if Input.is_action_just_pressed("model_material_switch") == true :
		MaterialLibrary.switch_material();

func get_move_input() -> Vector2 :
	var move_input : Vector2 = Vector2.ZERO;
	
	var left_input = Input.get_action_strength("move_left");
	if Input.is_action_pressed("move_left") == true :
		left_input += clamp(left_input + 1.0, 0.0, 1.0);
	
	var right_input = Input.get_action_strength("move_right");
	if Input.is_action_pressed("move_right") == true :
		right_input += clamp(right_input + 1.0, 0.0, 1.0);
	
	move_input.x -= left_input;
	move_input.x += right_input;
	move_input.y -= Input.get_action_strength("move_up");
	move_input.y += Input.get_action_strength("move_down");
	return move_input;

func get_look_input() -> Vector2 :
	var look_input : Vector2 = Vector2.ZERO;
	look_input.x -= Input.get_action_strength("look_left");
	look_input.x += Input.get_action_strength("look_right");
	look_input.y -= Input.get_action_strength("look_up");
	look_input.y += Input.get_action_strength("look_down");
	return look_input;

