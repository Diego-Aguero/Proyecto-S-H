extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D/CollisionShape2D.disabled = true
	$Ball.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	active()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("HurtboxPlayer") or area.is_in_group("HitboxPlayer"):
		$Timer.start()
		#print("dash disponible")

func active():
	if !$Timer.is_stopped():
		$Area2D/CollisionShape2D.disabled = true
		$Ball.self_modulate = Color(0, 0, 0, 137)
	else:
		$Area2D/CollisionShape2D.disabled = false
		$Ball.self_modulate = Color(70, 0, 166, 10)

func _on_visible_on_screen_notifier_2d_screen_entered():
	$Area2D/CollisionShape2D.disabled = false
	$Ball.visible = true

func _on_visible_on_screen_notifier_2d_screen_exited():
	$Area2D/CollisionShape2D.disabled = true
	$Ball.visible = false
