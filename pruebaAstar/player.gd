extends Node2D

var RADIO_SATISFACCION = 20
var graph = preload("res://Astar.gd").new()

var path
var fin
var actual

func _ready():
	path = graph.calculate_new_path(position, Vector2(350,350))
	fin = path.back()
	path.pop_front()
	actual = path.pop_front()
	$AnimatedSprite.play("walk")

func _physics_process(delta):
	if fin and position.distance_to(fin) > RADIO_SATISFACCION:
		if actual:
			if position.distance_to(actual) < RADIO_SATISFACCION:
				actual = path.pop_front()
		
			position += (actual - position).normalized() * 100 * delta
	else:
		$AnimatedSprite.animation = "idle"
		
func set_path(obj):
	path = graph.calculate_new_path(position, obj)
	fin = path.back()
	if path.size() != 1:
		path.pop_front()
	actual = path.pop_front()
	$AnimatedSprite.animation = "walk"
	if position.x - obj.x < 0:
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.flip_h = true