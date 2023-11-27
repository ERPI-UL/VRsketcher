extends Camera

func _process(delta : float) -> void :
	CameraData.direction_right = global_transform.basis.x;
	CameraData.direction_up = global_transform.basis.y;
	CameraData.direction_forward = -global_transform.basis.z;
