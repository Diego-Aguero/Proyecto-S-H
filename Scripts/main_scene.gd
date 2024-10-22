extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if $Boss == null:
		get_tree().change_scene_to_file("res://Scenes/win_screen.tscn")
