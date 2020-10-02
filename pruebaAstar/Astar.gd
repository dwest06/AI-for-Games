extends Node

const Cola = preload("res://Queue.gd")
const Node_ = preload("res://Node.gd")
const Connection = preload("res://Connection.gd")

var Nodes
var Connections

# Called when the node enters the scene tree for the first time.
func _init():
	Nodes = [
		Node_.new(0, 200, 200, 200, 0, 100, 100, 166, 100, 0),
		Node_.new(1, 200, 200, 300, 100, 200, 0, 233, 100, 0),
		Node_.new(2, 200, 0, 0, 0, 100, 100, 100, 33, 0),
		Node_.new(3, 300, 100, 400, 0, 200, 0, 300, 33, 0),
		Node_.new(4, 100, 100, 0, 200, 200, 200, 100, 166, 0),
		Node_.new(5, 0, 0, 0, 200, 100, 100, 33, 100, 0),
		Node_.new(6, 200, 200, 400, 200, 300, 100, 300, 166,0),
		Node_.new(7, 300, 100, 400, 200, 400, 0, 366, 100,0),
		Node_.new(8, 0, 200, 100, 300, 200, 200, 100, 233,0),
		Node_.new(9, 200, 200, 300, 300, 400, 200, 300, 233,0),
		Node_.new(10, 100, 300, 300, 300, 200, 200, 200, 266,0),
		Node_.new(11, 100, 300, 200, 400, 300, 300, 200, 333,0),
		Node_.new(12, 0, 200, 0, 400, 100, 300, 33, 300,0),
		Node_.new(13, 100, 300, 0, 400, 200, 400, 100, 366,0),
		Node_.new(14, 200, 400, 400, 400, 300, 300, 300, 366,0),
		Node_.new(15, 300, 300, 400, 400, 400, 200, 366, 300,0)
	]
	
	Connections = [
		[
		    Connection.new(0, 1, costo_entre_nodos(0, 1)),
		    Connection.new(0, 2, costo_entre_nodos(0, 2)),
		    Connection.new(0, 4, costo_entre_nodos(0, 4)),
		],
		[
		    Connection.new(1, 0, costo_entre_nodos(1, 0)),
		    Connection.new(1, 3, costo_entre_nodos(1, 3)),
		    Connection.new(1, 6, costo_entre_nodos(1, 6)),
		],
		[
		    Connection.new(2, 0, costo_entre_nodos(2, 0)),
		    Connection.new(2, 5, costo_entre_nodos(2, 5)),
		],
		[
		    Connection.new(3, 1, costo_entre_nodos(3, 1)),
		    Connection.new(3, 7, costo_entre_nodos(3, 7)),
		],
		[
			Connection.new(4, 0, costo_entre_nodos(4, 0)),
			Connection.new(4, 5, costo_entre_nodos(4, 5)),
			Connection.new(4, 8, costo_entre_nodos(4, 8)),
		],
		[
			Connection.new(5, 2, costo_entre_nodos(5, 2)),
			Connection.new(5, 4, costo_entre_nodos(5, 4)),
		],
		[
			Connection.new(6, 1, costo_entre_nodos(6, 1)),
			Connection.new(6, 7, costo_entre_nodos(6, 7)),
			Connection.new(6, 9, costo_entre_nodos(6, 9)),
		],
		[
			Connection.new(7, 3, costo_entre_nodos(7, 3)),
			Connection.new(7, 6, costo_entre_nodos(7, 6)),
		],
		[
			Connection.new(8, 4, costo_entre_nodos(8, 4)),
			Connection.new(8, 10, costo_entre_nodos(8, 10)),
			Connection.new(8, 12, costo_entre_nodos(8, 12)),
		],
		[
			Connection.new(9, 6, costo_entre_nodos(9, 6)),
			Connection.new(9, 10, costo_entre_nodos(9, 10)),
			Connection.new(9, 15, costo_entre_nodos(9, 15)),
		],
		[
			Connection.new(10, 8, costo_entre_nodos(10, 8)),
			Connection.new(10, 9, costo_entre_nodos(10, 9)),
			Connection.new(10, 11, costo_entre_nodos(10, 11)),
		],
		[
			Connection.new(11, 10, costo_entre_nodos(11, 10)),
			Connection.new(11, 13, costo_entre_nodos(11, 13)),
			Connection.new(11, 14, costo_entre_nodos(11, 14)),
		],
		[
			Connection.new(12, 8, costo_entre_nodos(12, 8)),
			Connection.new(12, 13, costo_entre_nodos(12, 13)),
		],
		[
			Connection.new(13, 11, costo_entre_nodos(13, 11)),
			Connection.new(13, 12, costo_entre_nodos(13, 12)),
		],
		[
			Connection.new(14, 11, costo_entre_nodos(14, 11)),
			Connection.new(14, 15, costo_entre_nodos(14, 15)),
		],
		[
			Connection.new(15, 9, costo_entre_nodos(15, 9)),
			Connection.new(15, 1, costo_entre_nodos(15, 1))
		]
	]

# Retorna la distancia entre el centro de un nodo i a un nodo j
func costo_entre_nodos(i, j):
	return Nodes[i].get_center().distance_to(Nodes[j].get_center())
	
# Heuristica Euclidiana porque si.
func heuristica(principio, final):
	return principio.get_center().distance_to(final.get_center())
	
# Devuelve el Nodo el cual pertenece un punto dado del mapa
func get_node(pos):
	for i in Nodes:
		if isInside(i.get_p1(), i.get_p2(), i.get_p3(), pos):
			return i

# Funcion que setea los costos de los nodos en INF
func set_nodes_inf():
	for i in Nodes:
		i.set_costo(INF)

# Devuelve las conexiones de un nodo
func get_connections(node):
	return Connections[node.get_id()]

# Hace A* dado dos Vectores, la posicion del jugador y la posicion del Mouse
func calculate_new_path(player_pos, mouse_pos):
	var nodo_inicial = get_node(player_pos)
	var nodo_final = get_node(mouse_pos)
	var abiertos = Cola.new()
	var proveniente = {}
	# Hacemos inf todos los nodos y el inicial 0
	set_nodes_inf()
	nodo_inicial.set_costo(0)
	
	abiertos.push(nodo_inicial)
	
	# Nodo que se esta verificando
	var current
	# Conexiones del nodo actual
	var connections
	# Nodo final relativo
	var endnode
	# Costo del nodo final relativo
	var costonode
	
	while( !abiertos.empty() ):
		current = abiertos.pop()
		
		if current.get_id() == nodo_final.get_id():
			break
		
		connections = get_connections(current)
		for connection in connections:
			endnode = Nodes[connection.get_to()]
			# Calculamos el costo desde el current hasta el endnode.
			costonode = current.get_costo() + connection.get_costo() + heuristica(current, nodo_final)
			# Si el nuevo costo es menor al costo que tenia el endnode
			if costonode < endnode.get_costo():
				# Cambiamos el costo
				endnode.set_costo(costonode)
				# Actualizamos de donde proviene el endnode
				proveniente[endnode.get_id()] = current.get_id()
				
				# Si no esta el nodo en la cola
				if !abiertos.has(endnode):
					# Se agrega
					abiertos.push(endnode)
					
	# Verificamos que realmente el ultimo nodo en current es el final
	if current.get_id() != nodo_final.get_id():
		return null
		
	# Camino minimo
	var path = [mouse_pos]
	# De donde viene el nodo current
	var de_donde_vino 
	
	# Iteramos hasta llegar al nodo inicial
	while current.get_id() != nodo_inicial.get_id():
		de_donde_vino = Nodes[proveniente[current.get_id()]]
		path.append(de_donde_vino.get_center())
		current = de_donde_vino
	path.invert()
	return path



#################
#	Calcular si un punto pertenece a un triangulo
#################
func area(p1, p2, p3): 
    return abs((p1.x * (p2.y - p3.y) + p2.x * (p3.y - p1.y) + p3.x * (p1.y - p2.y)) / 2.0) 
	
func isInside(p1, p2, p3, point): 
    # Calculate area of triangle ABC 
    var A = area (p1, p2, p3) 
    # Calculate area of triangle PBC  
    var A1 = area (point, p2, p3) 
    # Calculate area of triangle PAC  
    var A2 = area (p1, point, p3) 
    # Calculate area of triangle PAB  
    var A3 = area (p1, p2, point) 
    # Check if sum of A1, A2 and A3  
    # is same as A 
    if(A == A1 + A2 + A3): 
        return true
    else: 
        return false

######################