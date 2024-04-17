extends VRSketcher

func _ready() -> void :

	Project.connect("open_project", self, "open_project");

