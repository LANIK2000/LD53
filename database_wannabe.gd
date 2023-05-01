extends Node

var _data_dict = {}

func get_data(key: String):
	return _data_dict.get(key)

func set_data(key: String, value):
	_data_dict[key] = value
