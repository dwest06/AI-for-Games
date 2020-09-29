extends Node2D

const SPEED = 100
const RAYLEN = 64

var anisprite
var direction = Vector2()
var angulos_camara = [6.02139, 6.10865, 6.19592, 0, 0.087266, 0.174533, 0.261799]
var FAMOSOS
var fotografias = 0
var foto_flash = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)
	anisprite = $AnimatedSprite
	anisprite.play("idle")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	# Movimiento
	mover_personaje(delta)
	
	# Escondite
	verificar_escondite()
	
	# Mostar flash
	if foto_flash > 0:
		update()
		foto_flash-=delta


func verificar_escondite():

	if get_parent().isplayer_descubierto():
		get_parent().verifyEscondite(position)

func set_famoso(famoso):
	FAMOSOS = famoso

func _input(event):
	if event.is_action_pressed("ui_select"):
		foto_flash = 0.5
		# Avisamos a todos los famosos que fue tomada una foto
		for i in FAMOSOS:
			i.foto_tomada()
			
		var result = false
		for i in angulos_camara:
			var newvector = Vector2(cos(rotation + i), sin(rotation + i)).normalized() * RAYLEN  + position
			for j in FAMOSOS:
				result = result or toca_famoso(newvector, j)
			if i == 0:
				get_parent().set_circulo(newvector)
		if result:
			fotografias += 1
		print(result)

func toca_famoso(vect, fam):
	var x = vect.x - fam.position.x
	var y = vect.y - fam.position.y
	return pow(x,2) + pow(y,2) <= pow(fam.RADIUS,2)


func _draw():
	# Disparo de Camara con RAYCAST
	for i in angulos_camara:
		var v1 = Vector2.ZERO
		var v2 = Vector2(cos(i), sin(i)) * RAYLEN

		draw_line(v1, v2, Color(0, 1.0, 1.0, foto_flash * 2), 1)


# Funcion para verificar movimiento
func mover_personaje(delta):
	if Input.is_action_pressed("ui_up"):
		direction.y =  -1
		rotation = deg2rad(270)
		anisprite.play("walk")
	elif Input.is_action_pressed("ui_down"):
		direction.y =  1
		rotation = deg2rad(90)
		anisprite.play("walk")
	else:
		direction.y = 0
		
	if Input.is_action_pressed("ui_left"):
		direction.x =  -1
#		anisprite.flip_h = true
		rotation = deg2rad(180)
		anisprite.play("walk")
	elif Input.is_action_pressed("ui_right"):
		direction.x =  1
#		anisprite.flip_h = false
		rotation = deg2rad(0)
		anisprite.play("walk")
	else:
		direction.x = 0
		
	if direction == Vector2.ZERO:
		anisprite.play("idle")

	position += direction.normalized() * delta * SPEED

# Funcion que verifica si 2 restas acotadas se intersectan
func is_touch(a,b,c,d):
	var x1 = a.x
	var x2 = b.x
	var x3 = c.x
	var x4 = d.x

	var y1 = a.y
	var y2 = b.y
	var y3 = c.y
	var y4 = d.y
	
	var denom = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
	if denom == 0:
	    return false
	
	var t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / denom
	var u = - (((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) / denom)
	
	if 0.0 <= t and t <= 1.0 and 0 <= u and u <= 1:
	    return true
	else:
	    return false

