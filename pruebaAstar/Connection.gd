extends Node

var fromNode
var ToNode
var costo

func _init(f,t,c):
	fromNode = f
	ToNode = t
	costo = c
	
func get_from():
	return fromNode
	
func get_to():
	return ToNode
	
func get_costo():
	return costo
	

	