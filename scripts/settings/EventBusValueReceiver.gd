extends Node
class_name EventBusValueReceiver

export(String) var event_bus_signal_name : String = "";
export(String) var parent_property : String = "";

func _ready() -> void :
	if EventBus.connect(event_bus_signal_name, self, "set_parent_property") != OK :
		print("Can't connect EventBus signal " + event_bus_signal_name);

func set_parent_property(value) -> void :
	var target = null;
	
	var path : Array = parent_property.rsplit(".", false, 1);
	if path.size() > 1 :
		target = get_parent().get(path[0]);
		target.set(path[1], value);
	else :
		target.set(parent_property, value);
