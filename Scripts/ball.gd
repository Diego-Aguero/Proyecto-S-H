extends RigidBody2D

var initial_velocity = Vector2(300, -500) # Ajustar según sea necesario
var gravity = Vector2(0, 980) # Ajustar según sea necesario

func _ready():
	# Aplica la velocidad inicial cuando la bola se instancie
	if GLOBAL.facing_direction == -1:
		initial_velocity.x *= -1
	self.linear_velocity = initial_velocity
func _physics_process(delta):
	# Aplica la gravedad a la bola
	self.linear_velocity += gravity * delta
	linear_velocity.y = clamp(linear_velocity.y, -500, 700)
	static_mode()
	stuck_verifactionDown()
	stuck_verifactionUp()

func static_mode():
	if $RayCast2D.is_colliding():
		sleeping = true

# Verifica si el ShapeCast está collisionando para asi subir y evitar que se atasque
func stuck_verifactionDown():
	if $StuckDown.is_colliding():
		self.global_position.y -= 10
# Verifica si el ShapeCast está collisionando para asi bajar y evitar que se atasque
func stuck_verifactionUp():
	if $StuckUp.is_colliding():
		self.global_position.y += 5
		

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Limit"):
		self.queue_free()
