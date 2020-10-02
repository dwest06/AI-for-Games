extends Node

var id
var x1
var x2
var x3
var y1
var y2
var y3
var xcenter
var ycenter
var costo

func _init(_id,_x1, _y1, _x2, _y2, _x3, _y3, _xcenter, _ycenter, _costo):
	id = _id
	x1 = _x1
	x2 = _x2
	x3 = _x3
	y1 = _y1
	y2 = _y2
	y3 = _y3
	xcenter = _xcenter
	ycenter = _ycenter
	costo = _costo
	
func get_triangle():
	return [Vector2(x1,y1),Vector2(x2,y2),Vector2(x3,y3)]

func get_p1():
	return Vector2(x1,y1)
	
func get_p2():
	return Vector2(x2,y2)
	
func get_p3():
	return Vector2(x3,y3)
	
func get_center():
	return Vector2(xcenter,ycenter)
	
func get_costo():
	return costo
	
func set_costo(c):
	costo = c

func get_id():
	return id
	
	
	