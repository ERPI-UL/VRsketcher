extends Node
class_name ToolTip

onready var tooltip_text : Label3D = get_node("Pivot/Label3D");
onready var animation_player : AnimationPlayer = get_node("AnimationPlayer");

func _ready() -> void :
	EventBus.connect("tooltip_update_text", self, "update_tooltip_text");
	tooltip_text.text = "";

func update_tooltip_text(new_text : String) -> void :
	tooltip_text.text = new_text;
	animation_player.stop(true);
	animation_player.play("fade");
