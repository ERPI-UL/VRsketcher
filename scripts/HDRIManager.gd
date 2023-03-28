extends Node

var hdri_list : Array = [
	["default sky", 	"res://default_sky.tres",				"res://assets/hdri/icons/default sky.png"],
	["city 01",			"res://assets/hdri/city 01.hdr",		"res://assets/hdri/icons/city 01.png"],
	["city 02",			"res://assets/hdri/city 02.hdr",		"res://assets/hdri/icons/city 02.png"],
	["city 03",			"res://assets/hdri/city 03.hdr",		"res://assets/hdri/icons/city 03.png"],
	["city 04",			"res://assets/hdri/city 04.hdr",		"res://assets/hdri/icons/city 04.png"],
	["city 05",			"res://assets/hdri/city 05.hdr",		"res://assets/hdri/icons/city 05.png"],
	["city 06",			"res://assets/hdri/city 06.hdr",		"res://assets/hdri/icons/city 06.png"],
	["city 07",			"res://assets/hdri/city 07.hdr",		"res://assets/hdri/icons/city 07.png"],
	["forest 01",		"res://assets/hdri/forest 01.hdr",		"res://assets/hdri/icons/forest 01.png"],
	["interior 01",		"res://assets/hdri/interior 01.hdr",	"res://assets/hdri/icons/interior 01.png"],
	["interior 02",		"res://assets/hdri/interior 02.hdr",	"res://assets/hdri/icons/interior 02.png"],
	["outdoor 01",		"res://assets/hdri/outdoor 01.hdr",		"res://assets/hdri/icons/outdoor 01.png"],
	["outdoor 02",		"res://assets/hdri/outdoor 02.hdr",		"res://assets/hdri/icons/outdoor 02.png"],
	["sky 0",			"res://assets/hdri/sky 01.hdr",			"res://assets/hdri/icons/sky 01.png"],
	["sky 0",			"res://assets/hdri/sky 02.hdr",			"res://assets/hdri/icons/sky 02.png"],
	["sky 0",			"res://assets/hdri/sky 03.hdr",			"res://assets/hdri/icons/sky 03.png"],
	["studio 01",		"res://assets/hdri/studio 01.hdr",		"res://assets/hdri/icons/studio 01.png"]
]

onready var items_root : Control = get_node("ScrollContainer/HDRI_Manager");


func _ready() -> void :
	for c in items_root.get_children() :
		c.queue_free();

	for i in range(0, hdri_list.size()) :
		var item_button : Button = Button.new();
		item_button.flat = true;
		item_button.expand_icon = true;
		item_button.icon = load(hdri_list[i][2] as String);
		item_button.icon_align = Button.ALIGN_CENTER;
		item_button.rect_min_size = Vector2(75, 75);
		item_button.hint_tooltip = hdri_list[i][0];
		item_button.name = hdri_list[i][0];
		
		item_button.connect("pressed", self, "set_environement_hdri", [i]);
		
		items_root.add_child(item_button);

func set_environement_hdri(index : int = 0) -> void :

	if index == 0 :
		(get_tree().root.get_node("VRSketcher") as VRSketcher).world_environment.environment.background_sky = load("res://default_sky.tres");
	else :
		var panorama : PanoramaSky = PanoramaSky.new();
		panorama.panorama = load(hdri_list[index][1]);
		(get_tree().root.get_node("VRSketcher") as VRSketcher).world_environment.environment.background_sky = panorama;