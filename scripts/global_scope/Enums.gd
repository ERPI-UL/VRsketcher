extends Node

enum AxisCode {
	AXIS_X				= 0,
	AXIS_Y				= 1,
	AXIS_TRIGGER		= 2,
	AXIS_GRIP			= 4,
}

enum InputCode {
	BUTTON_MENU			= 3,
	BUTTON_B			= 1,
	BUTTON_A			= 7,
	BUTTON_GRIP			= 2,
	BUTTON_STICK		= 14,
	BUTTON_TRIGGER		= 15,

	STICK_BUTTON_UP		= 141,
	STICK_BUTTON_DOWN	= 142,
	STICK_BUTTON_LEFT	= 143,
	STICK_BUTTON_RIGHT	= 144,
}

enum ShortcutDirection {
	UP					= 0,
	DOWN				= 1,
	LEFT				= 2,
	RIGHT				= 3
}

enum ToolModeType {
	MAIN				= 0,
	SUB					= 1
}
