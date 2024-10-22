extends State
class_name ShootState
 
@export var bullet_node : PackedScene 
@onready var timer = $Timer
 
func transition():
	if ray_cast.is_colliding():
		var collided_object = ray_cast.get_collider() # Obtiene el objeto con el que colisiona el RayCast
		if not collided_object.is_in_group("player"):
			if owner.health > 8:
				get_parent().change_state("Follow")
			else:
				get_parent().change_state("Dash")
func enter():
	super.enter()
	timer.start()

func exit():
	super.exit()
	timer.stop()

func _on_timer_timeout():
	shoot()

func shoot():
	var bullet = bullet_node.instantiate()
	bullet.position = global_position
	bullet.direction = (GLOBAL.player_position - global_position).normalized()
	get_tree().current_scene.call_deferred("add_child", bullet)
	if owner.health <= 8:
		$Timer.wait_time = 0.1
