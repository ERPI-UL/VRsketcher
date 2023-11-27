extends Node

signal paint_color_changed(new_paint_color);

signal tool_switch_tool(tool_name);
signal tool_switch_next_tool();
signal tool_switch_previous_tool();

signal tool_set_shortcut(direction, shortcut_button);

signal tool_main_mode_switch(main_mode_index);
signal tool_sub_mode_switch(sub_mode_index);

signal tooltip_update_text(tooltip_text);

signal vr_enable_color_correction(value);

signal tools_menu_tooltip_update_text(tooltip_text);
