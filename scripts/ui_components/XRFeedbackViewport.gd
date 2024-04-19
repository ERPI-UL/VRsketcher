extends Viewport
class_name XRFeedbackViewport

export(NodePath) var xr_viewport_path : NodePath = "";
onready var xr_viewport : Viewport = get_node(xr_viewport_path);

func _ready() -> void :
	hdr = true;
	keep_3d_linear = true;
	render_target_clear_mode = CLEAR_MODE_ALWAYS;
	render_target_update_mode = Viewport.UPDATE_ALWAYS;

	xr_viewport.connect("size_changed", self, "update_size");
	update_size();

	var camera : CameraDataUpdater = CameraDataUpdater.new();
	camera.read_camera_data = true;
	add_child(camera);

func update_size() -> void :
	size = xr_viewport.size;
