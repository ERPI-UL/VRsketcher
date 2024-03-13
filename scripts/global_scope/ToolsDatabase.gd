extends Node

var tools : Dictionary = {
	"TOOL_NONE"				: {
		"name"		: "",
		"icon"		: null,
		"tool"		: null,
		"main_menu"	: null,
		"sub_menu"	: null
	},

	"TOOL_TELEPORT"			: {
		"name"		: "Téléportation",
		"icon"		: load("res://assets/icons/vr_tool_icons/tool_teleport.svg"),
		"tool"		: load("res://scenes/sketch_tools/teleport/Teleport.tscn").instantiate(),
		"main_menu"	: null,
		"sub_menu"	: null
	},

	"TOOL_PEN"				: {
		"name"		: "Dessiner",
		"icon"		: load("res://assets/icons/vr_tool_icons/tool_pen.svg"),
		"tool"		: load("res://scenes/sketch_tools/pen/Pen.tscn").instantiate(),
		"main_menu"	: load("res://scenes/sketch_tools/pen/pen_main_menu.tscn").instantiate(),
		"sub_menu"	: load("res://scenes/sketch_tools/pen/pen_sub_menu.tscn").instantiate()
	},
	"TOOL_ERASER"			: {
		"name"		: "Effacer",
		"icon"		: load("res://assets/icons/vr_tool_icons/tool_erase.svg"),
		"tool"		: load("res://scenes/sketch_tools/eraser/Eraser.tscn").instantiate(),
		"main_menu"	: null,
		"sub_menu"	: null
	},
	
	"TOOL_GRAB"				: {
		"name"		: "Saisir",
		"icon"		: load("res://assets/icons/vr_tool_icons/tool_grab.svg"),
		"tool"		: load("res://scenes/sketch_tools/grab/Grab.tscn").instantiate(),
		"main_menu"	: null,
		"sub_menu"	: null
	},
	"TOOL_MOVE"				: {
		"name"		: "Déplacer",
		"icon"		: load("res://assets/icons/vr_tool_icons/tool_move.svg"),
		"tool"		: load("res://scenes/sketch_tools/move/Move.tscn").instantiate(),
		"main_menu"	: load("res://scenes/sketch_tools/move/move_main_menu.tscn").instantiate(),
		"sub_menu"	: null
	},
	"TOOL_ROTATE"			: {
		"name"		: "Pivoter",
		"icon"		: load("res://assets/icons/vr_tool_icons/tool_rotate.svg"),
		"tool"		: load("res://scenes/sketch_tools/rotate/Rotate.tscn").instantiate(),
		"main_menu"	: load("res://scenes/sketch_tools/rotate/rotate_main_menu.tscn").instantiate(),
		"sub_menu"	: null
	},

	"TOOL_MODELER"			: {
		"name"		: "Modéliser",
		"icon"		: load("res://assets/icons/vr_tool_icons/tool_modeler.svg"),
		"tool"		: load("res://scenes/sketch_tools/modeler/Modeler.tscn").instantiate(),
		"main_menu"	: load("res://scenes/sketch_tools/modeler/modeler_main_menu.tscn").instantiate(),
		"sub_menu"	: null
	},
	"TOOL_MATERIAL_PAINT"	: {
		"name"		: "Texturer",
		"icon"		: load("res://assets/icons/vr_tool_icons/tool_texture_paint.svg"),
		"tool"		: load("res://scenes/sketch_tools/material_painter/MaterialPainter.tscn").instantiate(),
		"main_menu"	: load("res://scenes/sketch_tools/material_painter/material_painter_main_menu.tscn").instantiate(),
		"sub_menu"	: null
	},
	"TOOL_MEASUREMENT"		: {
		"name"		: "Mesurer",
		"icon"		: load("res://assets/icons/vr_tool_icons/tool_measurements.svg"),
		"tool"		: load("res://scenes/sketch_tools/measurement_tool/MeasurementTool.tscn").instantiate(),
		"main_menu"	: load("res://scenes/sketch_tools/measurement_tool/measurements_main_menu.tscn").instantiate(),
		"sub_menu"	: null
	},

	"TOOL_NOTE"			: {
		"name"		: "Note",
		"icon"		: load("res://assets/icons/vr_tool_icons/tool_note.svg"),
		"tool"		: load("res://scenes/sketch_tools/note_tool/NoteTool.tscn").instantiate(),
		"main_menu"	: load("res://scenes/sketch_tools/note_tool/note_main_menu.tscn").instantiate(),
		"sub_menu"	: null
	}
}

func get_tool(tool_name : String) -> SketchTool :
	if tools.has(tool_name) == true :
		return tools[tool_name]["tool"] as SketchTool;
	return null;

func get_tool_name(tool_name : String) -> String :
	if tools.has(tool_name) == true :
		return tools[tool_name]["name"] as String;
	return "INVALID_TOOL_NAME";

func get_tool_icon(tool_name : String) -> Texture2D :
	if tools.has(tool_name) == true :
		return tools[tool_name]["icon"] as Texture2D;
	return null;

func get_tool_main_menu(tool_name : String) -> Control :
	if tools.has(tool_name) == true :
		return tools[tool_name]["main_menu"] as Control;
	return null;

func get_tool_sub_menu(tool_name : String) -> Control :
	if tools.has(tool_name) == true :
		return tools[tool_name]["sub_menu"] as Control;
	return null;
