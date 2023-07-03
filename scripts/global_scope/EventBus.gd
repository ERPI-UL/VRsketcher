extends Node

signal paint_color_changed(new_paint_color);

signal tool_switch_tool(tool_name);
signal tool_switch_next_tool();
signal tool_switch_previous_tool();

signal tool_mode_switch(mode_index);

signal tool_sub_mode_switch(sub_mode_index);
