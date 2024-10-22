extends CharacterBody2D

@export var speed : int
@export var gravity : int
@export var can_move: bool
@export var jump_force : int
@export var dash_force_x : int
@export var dash_force_y : int
@export var teleport_impulse : int
@export var unlocked_teleport : bool
@export var unlocked_dash : bool
@export var can_dash : bool
@export var dash_deceleration : int
@export var unlocked_double_jump : bool
@export var unlocked_wall_jump : bool
@export var wall_slide_speed : int 
@export var walljump_force_x : int 
@export var walljump_force_y : int
@export var can_double_jump : bool
var jump_time_max = 0.20  # Tiempo máximo que puede durar el salto regulable
var jump_gravity = 350
var jump_time_current = 0.0  # Tiempo actual del salto
var is_jumping = false  # Para saber si el personaje está saltando
var dash : bool
var coyote_time : bool
var last_direction : Vector2
var avaible_second_jump : bool
var avaible_dash : bool
var avaible_tp : bool
var can_throw : bool
var ball = null
var is_processing_death = false
var ball_scene = preload("res://Scenes/ball.tscn")
@onready var collision_shape_hitbox = $HitboxPlayer/CollisionShape2D
@onready var collision_shape_hurtbox = $HurtboxPlayer/CollisionShape2D

func _ready():
	coyote_time = true
	GLOBAL.player_position = self.global_position

func _process(delta):
	if not dash: #gravedad
		velocity.y += gravity * delta
		velocity.y = clamp(velocity.y, -500, 500)  # Limita la velocidad en el eje Y, manteniendo un mínimo de 0  Limita la velocidad en el eje Y a max_velocity_y
	if is_on_floor():
		$Coyote_timer.start()  # Inicia el timer cuando el personaje está en el suelo
	else:
		if not $Coyote_timer.is_stopped():
			coyote_time = true  # Permite saltar durante el coyote time si el personaje no está en el suelo
	mechanics_ctrl()
	verify_transport() 
	move_and_slide()
	GLOBAL.player_position = self.global_position

func mechanics_ctrl():
	walk_ctrl()
	jump_ctrl()
	dash_ctrl()
	double_jump()
	wall_slide()
	wall_jump()
	throw_and_teleport()
	stuck_verification()
	attack_ctrl()


func walk_ctrl():
	if can_move == true:
		if not dash: 
			var input_x = GLOBAL.get_axis().x 
			velocity.x = input_x * speed
			
			if input_x != 0: 
				last_direction.x = sign(input_x)
				GLOBAL.facing_direction = sign(input_x)  # Actualiza la dirección en la que está mirando el personaje
				# Voltear el sprite y el collider cuando se mueve hacia la izquierda
				if last_direction.x == -1:
					$Sprite2D.scale.x = -1
					$HitboxPlayer.scale.x = -1
				else:
					$Sprite2D.scale.x = 1
					$HitboxPlayer.scale.x = 1

func jump_ctrl():
	# Comienza el salto si está en el suelo o en coyote_time y se presiona el botón de salto
	if (is_on_floor() or coyote_time) and Input.is_action_just_pressed("jump") and dash == false:
		#gravity = jump_gravity  # Ajusta la gravedad para el salto
		velocity.y = -jump_force  # Aplica la fuerza de salto inicial
	# Si el personaje está cayendo, aplica una gravedad mayor
	if not is_jumping and velocity.y > 0:
		gravity = 700  # Ajusta este valor para hacer la caída más lenta

func double_jump():
	if unlocked_double_jump == true and avaible_second_jump == true and Input.is_action_just_pressed("jump") and not is_on_floor() and coyote_time == false and dash == false and can_double_jump == true:
		velocity.y = -jump_force
		avaible_second_jump = false  # Restablece second_jump a false después de usar el doble salto
func verify_transport():
	if is_on_floor():
		if unlocked_double_jump:
			avaible_second_jump = true   # Restablece las variables a true cuando el personaje está en el suelo
		is_jumping = false
		if!$floor_verification_dash.is_stopped():
			avaible_dash = false
		else: 
			avaible_dash = true
		if!$floor_verification_tp.is_stopped():
			avaible_tp = false
		else: 
			avaible_tp = true
		#print("tp disponible")
func dash_ctrl():
	if can_dash and unlocked_dash and Input.is_action_just_pressed("dash") and avaible_dash == true:
		$floor_verification_dash.start()
		dash = true
		can_dash = false
		avaible_dash = false
		#print("1")
		var axis_x = GLOBAL.get_axis().x
		var axis_y = GLOBAL.get_axis().y
		if axis_x != 0 or axis_y != 0:
			velocity.x = dash_force_x * sign(axis_x)
			velocity.y = dash_force_y * sign(axis_y)
			last_direction.x = sign(axis_x)
		else:
			velocity.x = dash_force_x * GLOBAL.facing_direction  # Dashea en la dirección en la que está mirando el personaje
			velocity.y = 0  # Restablece la velocidad en el eje Y a 0
		$Dash.start()
func _on_dash_timeout():
	dash = false
	#print("2")
	if velocity.y < 0:  # Solo aplica la desaceleración si el dash va hacia arriba
		velocity.y = dash_deceleration
	$CanDash.start()
func _on_can_dash_timeout():
	#print("3")
	can_dash = true
func wall_slide():
	if is_on_wall_only() and velocity.y >= -180 and unlocked_wall_jump == true and unlocked_double_jump == true:
		velocity.y = wall_slide_speed
		can_double_jump = false
	else:
		can_double_jump = true
func wall_jump():
	# Verifica el wall jump hacia la izquierda
	if !is_on_floor() and $VerificatorLeft.is_colliding() == true and unlocked_wall_jump == true:
		$CoyoteWallJump.start()
		$CoyoteCastWallJumpLeft.enabled = true
	if $CoyoteCastWallJumpLeft.is_colliding() == true and Input.is_action_just_pressed("jump") and unlocked_wall_jump == true:
		$WallJumping.start()
		can_move = false
		velocity.y = walljump_force_y
		velocity.x = walljump_force_x
	# Verifica el wall jump hacia la derecha
	if !is_on_floor() and $VerificatorRight.is_colliding() == true and unlocked_wall_jump == true:
		$CoyoteWallJump.start()
		$CoyoteCastWallJumpRight.enabled = true
	if $CoyoteCastWallJumpRight.is_colliding() == true and Input.is_action_just_pressed("jump") and unlocked_wall_jump == true:
		$WallJumping.start()
		can_move = false
		velocity.y = walljump_force_y
		velocity.x = -walljump_force_x
func throw_and_teleport():
	if Input.is_action_just_pressed("throw") and unlocked_teleport == true and avaible_tp == true:
		if ball == null:
			ball = ball_scene.instantiate() # Instancia la pelota si no existe
			get_tree().root.add_child(ball) # Añade la bola al nodo raíz del escenario en lugar de al jugador
			ball.global_position = global_position   
		elif ball != null:
			var ball_position = ball.global_position # Si la pelota ya existe, guarda su posición
			ball.queue_free()# Elimina la pelota
			ball = null
			# Teletransporta al personaje a la posición de la pelota
			ball_position.y -= 10  # Resta "x" píxeles a la posición del eje y
			global_position = ball_position 
			velocity.y = teleport_impulse
			#print("tp no disponible")
			avaible_tp = false
			$floor_verification_tp.start()
			
func stuck_verification():
	if $Stuck.is_colliding():
		self.global_position.y -= 100
func _on_coyote_timer_timeout():
	coyote_time = false  #Desactiva el coyote time cuando el timer se detiene
var is_ball_throwed : bool # mover con las otras variables
func _on_hurtbox_player_area_entered(area : Area2D):
	if area.is_in_group("HitboxEnemy") and GLOBAL.isAlive:
		GLOBAL.isAlive = false  # Evita que el código se ejecute dos veces
		GLOBAL.deaths += 1
		if GLOBAL.is_checkpoint_active:
			global_position = GLOBAL.checkpoint_position
			if ball != null:
				ball.queue_free()
			is_ball_throwed = true
		else: 
			global_position = Vector2(0, 0)
		GLOBAL.isAlive = true
		if ball != null:
			ball.queue_free()
	if area.is_in_group("DashExtender"):
		avaible_dash = true
		print("otro dash")

func attack_ctrl():
	if dash == true:
		$ActiveHitbox.start()
		collision_shape_hitbox.disabled = false
		collision_shape_hurtbox.disabled = true
		$Sprite2D.self_modulate = Color(0.392, 0, 0.84)

func _on_active_hitbox_timeout():
	collision_shape_hitbox.disabled = true
	collision_shape_hurtbox.disabled = false
	$Sprite2D.self_modulate = Color(1, 1, 1)

func _on_wall_jumping_timeout() -> void:
	can_move = true

func _on_coyote_wall_jump_timeout() -> void:
	$CoyoteCastWallJumpLeft.enabled = false
	$CoyoteCastWallJumpRight.enabled = false

func _on_hitbox_player_area_entered(area: Area2D) -> void:
	if area.is_in_group("DashExtender"):
		$floor_verification_dash.start()
		avaible_dash = true

func _on_map_limits_verificator_area_entered(area: Area2D) -> void:
	if area.is_in_group("Limit") and GLOBAL.isAlive and not is_processing_death:
		is_processing_death = true
		$Death.start()
		GLOBAL.isAlive = false  # Evita que el código se ejecute dos veces
		GLOBAL.deaths += 1
		if GLOBAL.is_checkpoint_active:
			global_position = GLOBAL.checkpoint_position
			if ball != null:
				ball.queue_free()
			is_ball_throwed = true
		else: 
			global_position = Vector2(0, 0)
		GLOBAL.isAlive = true
		if ball != null:
			ball.queue_free()
	
	
	
	if area.is_in_group("DoubleJumpUnlocker"):
		unlocked_double_jump = true
	if area.is_in_group("WallJumpUnlocker"):
		unlocked_wall_jump = true
	if area.is_in_group("TeleportUnlocker"):
		unlocked_teleport = true


func _on_death_timeout():
	is_processing_death = false
