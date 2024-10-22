extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	show_deaths()

func show_deaths():
	text = "Muertes: " + str(GLOBAL.deaths)
