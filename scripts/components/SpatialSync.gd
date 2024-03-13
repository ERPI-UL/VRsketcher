@tool
extends Node3D
class_name SpatialSync

const NODE_SEARCH_DEPTH : int = 16;

@export var sync_on_start: bool = true;
@export var target_path: NodePath = "";

var node_to_sync_to : Node3D;


func _ready() -> void:
	if sync_on_start == true :
		sync_node();

func _process(_delta : float) -> void :
	if node_to_sync_to != null :
		global_transform = node_to_sync_to.global_transform;

func sync_node(new_node : Node3D = null) -> void :
	if new_node != null :
		node_to_sync_to = new_node;
		return;

	if target_path != null :
		node_to_sync_to = get_node(target_path);
		return;

	var depth : int = 0;
	var potential_node : Node = get_parent();
	while depth < NODE_SEARCH_DEPTH :
		potential_node = potential_node.get_parent();
		if potential_node is Node3D :
			node_to_sync_to = potential_node;
			return;
		depth += 1;
		
	node_to_sync_to = null;
