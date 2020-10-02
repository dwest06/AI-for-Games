extends Node

var cola = []

# Inicializamos la cola
func _init():
	cola = []
	
func push(item):
    cola.append(item)
    cola.sort_custom(self, "customComparison")
	
func empty():
	return cola.empty()
	
func size():
	return cola.size()
	
func top():
	if empty():
		return null
	return cola[0]
	
func pop():
	var top = top()
	if top == null: 
        return null
        
	return cola.pop_front()
	
func has(item):
	var id = item.get_id()
	for i in cola:
		if i.get_id() == id:
			return true
	return false

func customComparison(a, b):
    return a.get_costo() < b.get_costo()