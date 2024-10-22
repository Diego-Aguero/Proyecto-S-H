extends Control



func _on_quit_pressed():
	get_tree().quit()


func _on_button_pressed():
	OS.shell_open("https://www.instagram.com/blossomgamesstudio/");
