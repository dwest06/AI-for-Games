extends Node2D

const WAIT_SECONDS = 3
const MOVEMENT_SHORT = 50
const MOVEMENT_LONG = 200
const DISTANCE_TO_PLAYER = 250
const DISTANCE_TO_PLAYER_MIN = 70
const angulos_camara = [5.759586, 5.934119, 6.10865, 0, 0.174533, 0.349065, 0.523598]
const RAYLEN = 120
const RADIUS = 18


var center_window
var PLAYER
var ID
var time_count = 0
var huir = false
var incremento_foto = 0
var parent
var mirar = false

# Called when the node enters the scene tree for the first time.
func _ready():
	center_window = Vector2(480,320)
	parent = get_parent()

func _physics_process(delta):
	
	# Verificar que el NPC no este viendo u oyendo al PLAYER
	verificar_player_position()
	
#	Si no esta huyendo, hace una especie de wander
	if not huir:
		if time_count > WAIT_SECONDS - 0.5:
			if time_count > WAIT_SECONDS:
				time_count = 0
				incremento_foto = 0
				rotation += randf() * 2 * signo()
			else:
				move_wander(delta)
			
		time_count += delta
	else:
		move_huir(delta)
	
	# Verificar si el estado global es que descubrieron al juagdor
	if parent.isplayer_descubierto():
		mirar = true
	else:
		mirar = false
	# Si mirar activo activo
	
	if mirar:
		mirar_player()
		

# Raliza un 
func mirar_player():
	var orient_f_p = position.direction_to(PLAYER.position)
	rotation = atan2(orient_f_p.y, orient_f_p.x)
	
	
	
# Funcion para movimiento del personaje mientras no hace interactua con el jugador
func move_wander(delta):
	var vector
	# Si esta muy lejos del centro de la pantalla va en direccion al centro  
	# para que siempre este visible en la pantalla
	if position.distance_to(center_window) >= 300:
		vector = position.direction_to(center_window)
	else:
		vector = Vector2(sin(rotation), cos(rotation))
	position += vector.normalized() * MOVEMENT_SHORT * delta


# Movimiento del personaje mientras huye
func move_huir(delta):
	if position.distance_to(PLAYER.position) > DISTANCE_TO_PLAYER:
		huir = false
	else:
		var direction = -1 * position.direction_to(PLAYER.position)
		position += direction.normalized() * MOVEMENT_LONG * delta

# Verifica la posicion con respecto al player
func verificar_player_position():
	# VERIFICAR SI VE AL PLAYER
	for i in angulos_camara:
		var newvector = Vector2(cos(rotation + i), sin(rotation + i)).normalized() * RAYLEN  + position
		if toca_player(newvector):
			# Indicamos que este NPC ha visto al PLAYER
			$vista.show()
			# Realizamos la Accion de HUIR
			huir = true
			# Indica al estado global que este npc fue el que descubrio al fotografo
			get_parent().set_descubierto(ID)
			
	# VERIFICA SI EL PLAYER ESTA CERCA
	if PLAYER.position.distance_to(position) < DISTANCE_TO_PLAYER:
		$Sprite.show()
		if PLAYER.position.distance_to(position) < DISTANCE_TO_PLAYER_MIN + incremento_foto:
			$sonido.show()
			huir = true
			# Indica al estado global que este npc fue el que descubrio al fotografo
			get_parent().set_descubierto(ID)
	else:
		$vista.hide()
		$sonido.hide()
		$Sprite.hide()
	
# Retorna true si el vector intercede con la posicion del jugador
func toca_player(vect):
	var x = vect.x - PLAYER.position.x
	var y = vect.y - PLAYER.position.y
	return pow(x,2) + pow(y,2) <= pow(RADIUS,2)
	

# Guarda el player
func set_player(player):
	PLAYER = player
	
# Guarda el id del NPC
func set_id(id):
	ID = id
	
func foto_tomada():
	incremento_foto = 100
	time_count = 0
	
# funcion util para obtener 1 o -1 aleatoreamente
func signo():
	if randf() > 0.5:
		return -1
	else:
		return 1
	
func _draw():
	# Disparo de Camara con RAYCAST
	for i in angulos_camara:
		var v1 = Vector2.ZERO
		var v2 = Vector2(cos(i), sin(i)) * RAYLEN
#		v2.x += RAYLEN
		
		draw_line(v1, v2, Color(255, 0, 0), 1)