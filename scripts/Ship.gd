extends Area2D

@export var neededScrap:int = 1 

func fixScrap():
	neededScrap -= 1
	if neededScrap == 0:
		Win()

func Win():
		get_tree().change_scene_to_file("res://scenes/won.tscn")
