extends Node3D

func _ready() -> void :
	return
	#var args : Array = Array(OS.get_cmdline_args());
	#if args.size() > 0 :
	#	import_model(args[0], 0.1);
	#else :
	#	import_model("D:/Users/michaux2/Downloads/cplt-c1d5.stl", 0.1);
	#	import_model("D:/Users/michaux2/Downloads/cplt-k2-6.stl", 0.1);
	#	import_model("D:/Users/michaux2/Downloads/cplt-k2-6.stl", 0.05);
