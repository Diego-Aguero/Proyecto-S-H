extends CharacterBody2D

@onready var ray_cast = $RayCast2D
@onready var progress_bar = $ProgressBar
@onready var sprite = $Sprite2D

var direction = Vector2.RIGHT
var speed =  200.0
var health: int = 16:
	set(value):
		health = value
		progress_bar.value = health

func _ready() -> void:
	set_physics_process(false)
	progress_bar.max_value = health # Se asegura de que la barra refleje la salud máxima al iniciar
	$RayCast2D.collide_with_areas = false
	$Sprite2D.visible = false
	$ProgressBar.visible = false
	$HurtboxBoss/CollisionShape2D.disabled = true
	$Area2D/CollisionShape2D.disabled = true
	
func _process(_delta):
	direction = (GLOBAL.player_position - global_position).normalized()
	ray_cast.target_position = direction * 300
	velocity = direction * speed
	if velocity.x < 0:
		$Sprite2D.flip_h = true
	elif velocity.x > 0:
		$Sprite2D.flip_h = false
	if health <= 8:
		sprite.modulate = Color(1, 0, 0)
	else:
		sprite.modulate = Color(1, 1, 1)
func _physics_process(_delta: float) -> void:
	move_and_slide()

func _on_hurtbox_boss_area_entered(area: Area2D) -> void:
	if area.is_in_group("HitboxPlayer"):
		health -= 1
		if health <= 0:
			queue_free()  # Elimina al boss si su salud llega a 0

func _on_visible_on_screen_notifier_2d_screen_entered():
	$RayCast2D.collide_with_areas = true
	$Sprite2D.visible = true
	$ProgressBar.visible = true
	$HurtboxBoss/CollisionShape2D.disabled = false
	$Area2D/CollisionShape2D.disabled = false

func _on_visible_on_screen_notifier_2d_screen_exited():
	$Sprite2D.visible = false
	$ProgressBar.visible = false

func _on_area_2d_area_entered(area):
	if area.is_in_group("HurtboxPlayer"):
		health = 16
