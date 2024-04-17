extends Node

# Called when the node enters the scene tree for the first time.
func _ready() :
	yield(get_tree(), "idle_frame");
	if ["Android"].find(OS.get_name()) >= 0 :
		#Meta Quest mode
		var scene : PackedScene = load("res://XR_VRSketcher.tscn");
		get_tree().root.add_child(scene.instance());
	else :
		#Desktop mode
		var scene : PackedScene = load("res://VRSketcher.tscn");
		get_tree().root.add_child(scene.instance());
