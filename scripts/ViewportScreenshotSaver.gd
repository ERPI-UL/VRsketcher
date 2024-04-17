extends Node
class_name ViewportScreenshotSaver

func _ready() -> void :
	if get_parent() is Viewport :
		if EventBus.connect("save_screenshot", self, "save_screenshot") != OK :
			print("Can't connect EventBus signal save_screenshot");

func save_screenshot(file_name : String) -> void :
	var screenshot : Image = (get_parent() as Viewport).get_texture().get_data();
	screenshot.flip_y();
	screenshot.save_png(file_name);
	print("Saved screenshot to : " + file_name);
