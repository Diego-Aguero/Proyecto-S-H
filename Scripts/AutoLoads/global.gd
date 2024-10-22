extends Node

# Movimiento del player, ejes de movimiento.
var axis : Vector2
var facing_direction = 1 
var checkpoint_position 
var is_checkpoint_active : bool
var isAlive = true
var player_position
var deaths: int
#func _process(_delta: float) -> void:
	#print("la posicion del player es: ", player_position)
	
# Función para retornar la dirección pulsada.
func get_axis() -> Vector2:
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_up")) - int(Input.is_action_pressed("ui_down"))
	return axis.normalized()
	
