extends Node

func switch_environment_hdri() -> void :
	var hdri_manager : HDRIManager = (get_tree().root.get_node("VRSketcher") as VRSketcher).hdri_manager;
	
	var hdri_index : int = hdri_manager.current_hdri_index + 1;
	if hdri_index >= hdri_manager.hdri_list.size() :
		hdri_index = 0;
	
	hdri_manager.set_environement_hdri(hdri_index);

func switch_global_material() -> void :
	MaterialLibrary.switch_material();
