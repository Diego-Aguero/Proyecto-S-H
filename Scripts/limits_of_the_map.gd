extends Node2D

@onready var visibility_notifier = $VisibleOnScreenNotifier2D

func _ready():
	$Area2D/CollisionShape2D.disabled = true

func _on_visible_on_screen_notifier_2d_screen_entered():
	$Area2D/CollisionShape2D.disabled = false


func _on_visible_on_screen_notifier_2d_screen_exited():
	$Area2D/CollisionShape2D.disabled = true
