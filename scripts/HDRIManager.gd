extends Node
class_name HDRIManager

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
	["interior 03",		"res://assets/hdri/interior 03.hdr",	"res://assets/hdri/icons/interior 03.png"],
	["interior 04",		"res://assets/hdri/interior 04.hdr",	"res://assets/hdri/icons/interior 04.png"],
	["interior 05",		"res://assets/hdri/interior 05.hdr",	"res://assets/hdri/icons/interior 05.png"],
	["interior 06",		"res://assets/hdri/interior 06.hdr",	"res://assets/hdri/icons/interior 06.png"],
	["interior 07",		"res://assets/hdri/interior 07.hdr",	"res://assets/hdri/icons/interior 07.png"],

	["outdoor 01",		"res://assets/hdri/outdoor 01.hdr",		"res://assets/hdri/icons/outdoor 01.png"],
	["outdoor 02",		"res://assets/hdri/outdoor 02.hdr",		"res://assets/hdri/icons/outdoor 02.png"],
	["outdoor 03",		"res://assets/hdri/outdoor 03.hdr",		"res://assets/hdri/icons/outdoor 03.png"],

	["sky 01",			"res://assets/hdri/sky 01.hdr",			"res://assets/hdri/icons/sky 01.png"],
	["sky 02",			"res://assets/hdri/sky 02.hdr",			"res://assets/hdri/icons/sky 02.png"],
	["sky 03",			"res://assets/hdri/sky 03.hdr",			"res://assets/hdri/icons/sky 03.png"],

	["studio 01",		"res://assets/hdri/studio 01.hdr",		"res://assets/hdri/icons/studio 01.png"],

	["alien 01",		"res://assets/hdri/alien 01.hdr",		"res://assets/hdri/icons/alien 01.png"],
	["alien 02",		"res://assets/hdri/alien 02.hdr",		"res://assets/hdri/icons/alien 02.png"]
];

var current_hdri_index : int = 0;

onready var items_root : Control = get_node("ScrollContainer/FlexGridContainer");

func _ready() -> void :
	if EventBus.connect("environment_set_hdri", self, "set_environement_hdri") != OK :
		print("Can't connect EventBus signal set_environement_hdri");
	if EventBus.connect("environment_next_hdri", self, "next_environment_hdri") != OK :
		print("Can't connect EventBus signal next_environment_hdri");

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

		if item_button.connect("pressed", self, "set_environement_hdri", [i]) != OK :
			print("Can't connect item_button signal set_environement_hdri");

		items_root.add_child(item_button);

func set_environement_hdri(index : int = 0) -> void :
	current_hdri_index = index;
	if current_hdri_index >= hdri_list.size() :
		current_hdri_index = 0;

	Project.current_project["current_hdri_index"] = current_hdri_index;

	if current_hdri_index == 0 :
		EventBus.emit_signal("environment_sky_updated", load("res://default_sky.tres"));
	else :
		var panorama : PanoramaSky = PanoramaSky.new();
		panorama.panorama = load(hdri_list[current_hdri_index][1]);
		EventBus.emit_signal("environment_sky_updated", panorama);

func next_environment_hdri() -> void :
	set_environement_hdri(current_hdri_index + 1);

func set_environement_exposure(value : float) -> void :
	Project.current_project["current_exposure"] = value;
	EventBus.emit_signal("environment_set_exposure", value);
