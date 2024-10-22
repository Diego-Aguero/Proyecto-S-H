extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape2D.disabled = true
	
	

func _on_visible_on_screen_notifier_2d_screen_entered():
	$CollisionShape2D.disabled = false

func _on_visible_on_screen_notifier_2d_screen_exited():
	$CollisionShape2D.disabled = true
