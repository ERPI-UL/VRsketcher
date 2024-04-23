extends Node

onready var tooltip_text : Label = get_node("Panel/Label");
onready var animation_player : AnimationPlayer = get_node("AnimationPlayer");

func _ready() -> void :
	if EventBus.connect("ui_notification_message", self, "update_tooltip_text") != OK :
		print("Can't connect EventBus signal ui_notification_message");
	tooltip_text.text = "";

func update_tooltip_text(new_text : String) -> void :
	tooltip_text.text = new_text;
	animation_player.stop(true);
	animation_player.play("fade");
