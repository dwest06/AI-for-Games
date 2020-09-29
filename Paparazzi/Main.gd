extends Node2D

var player
var famoso
var famoso2
var famoso3
var famoso4
var circulo = Vector2.ZERO

var escondites = [
	Rect2(Vector2(0, 480), Vector2(192,160)),
	Rect2(Vector2(352, 320), Vector2(128,128))
]
export var tiempo = 30

var global_state = {
	"descubierto": 0,
	"visto": false
}

# Called when the node enters the scene tree for the first time.
func _ready():
	player = $Player
	famoso = $Famoso
	famoso2 = $Famoso2
	famoso3 = $Famoso3
	famoso4 = $Famoso4
	famoso.set_player(player)
	famoso.set_id(1)
	famoso2.set_player(player)
	famoso2.set_id(2)
	famoso3.set_player(player)
	famoso3.set_id(3)
	famoso4.set_player(player)
	famoso4.set_id(4)
	player.set_famoso([famoso,famoso2, famoso3, famoso4])
	$segundos.start()
	$Timer.wait_time = tiempo
	$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$RichTextLabel.text = "Fotografias: " + str(player.fotografias) + "\nTiempo: " + str(tiempo)
	
func set_circulo(a):
	circulo = a
	

func _on_Timer_timeout():
	$Final.text = "Se ha acabdo el tiempo \nPuntuacion: " + str(player.fotografias)
	$Final.show()
	get_tree().paused = true


func _on_segundos_timeout():
	tiempo -= 1


# Funciones para controlar quien es el que lo vio
func getDescubierto():
	return global_state.descubierto
	
func set_descubierto(id):
	global_state.descubierto = id
	
func reset_descubierto():
	global_state.descubierto = 0
	
func isplayer_descubierto():
	return global_state.descubierto > 0
	
	
# Funciones para escondite
func verifyEscondite(point: Vector2):
	var escondido = false
	for i in escondites:
		escondido = i.has_point(point)
		if escondido:
			reset_descubierto()
			return escondido
	
	return escondido
		
