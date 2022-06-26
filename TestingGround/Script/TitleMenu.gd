extends Control

func _ready():
	DataManager.play_music("plant_in_a_hurry")

func _on_Button_pressed():
	DataManager.add_child(DataManager.ui)
	var _err = get_tree().change_scene("res://Scene/WindowSeal.tscn")
