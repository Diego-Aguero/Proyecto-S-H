extends State
class_name IdleState
 
func transition():
	if ray_cast.is_colliding():
		var collided_object = ray_cast.get_collider() # Obtiene el objeto con el que colisiona el RayCast
		if collided_object.is_in_group("player"):
			get_parent().change_state("Shoot")
