extends Node2D

@export var IsCheckPointActivated: bool
@onready var checkpoint = $"." 

func _ready():
	$Area2D/CollisionShape2D.disabled = true
	$Sprite2D.visible = false

func _process(_delta):
	pass
	#checkpointActive()

# Cuando el área 2D del checkpoint detecta la entrada del jugador
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("HurtboxPlayer"):
		GLOBAL.is_checkpoint_active = true
		GLOBAL.checkpoint_position = checkpoint.global_position
 
func _on_visible_on_screen_notifier_2d_screen_entered():
	$Area2D/CollisionShape2D.disabled = false
	$Sprite2D.visible = true

func _on_visible_on_screen_notifier_2d_screen_exited():
	$Area2D/CollisionShape2D.disabled = true
	$Sprite2D.visible = false
