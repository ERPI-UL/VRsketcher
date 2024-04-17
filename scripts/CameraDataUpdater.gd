extends Camera

export(bool) var read_camera_data : bool = false;

func _process(_delta : float) -> void :
	if read_camera_data == false :
		CameraData.direction_right = global_transform.basis.x;
		CameraData.direction_up = global_transform.basis.y;
		CameraData.direction_forward = -global_transform.basis.z;

		CameraData.camera_global_transform = global_transform;
	else :
		global_transform = CameraData.camera_global_transform;
