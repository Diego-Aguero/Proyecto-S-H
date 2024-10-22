extends CharacterBody2D
func _ready():
	$Sprite2D.visible = false
	$HitboxEnemy/CollisionShape2D.disabled = true
	$HurtboxEnemy/CollisionShape2D.disabled = true
	$CollisionShape2D.disabled = true

func _process(_delta):
	pass
	

func _on_hurtbox_enemy_area_entered(area):
	if area.is_in_group("HitboxPlayer"):
		self.queue_free()


func _on_visible_on_screen_notifier_2d_screen_entered():
	$Sprite2D.visible = true
	$HitboxEnemy/CollisionShape2D.disabled = false
	$HurtboxEnemy/CollisionShape2D.disabled = false
	$CollisionShape2D.disabled = false


func _on_visible_on_screen_notifier_2d_screen_exited():
	$Sprite2D.visible = false
	$HitboxEnemy/CollisionShape2D.disabled = true
	$HurtboxEnemy/CollisionShape2D.disabled = true
	$CollisionShape2D.disabled = true
