extends Camera2D


@onready var player = get_parent().get_node("Player")
@onready var checkpoint = get_parent().get_node("CheckPoint")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player != null:
		global_position = player.global_position


# TODO: Arreglar la camara, cuando el player se desinstancia se rompe el juego.
