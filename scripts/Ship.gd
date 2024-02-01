extends Area2D

@export var neededScrap:int = 10 
var prefix = "Electronic scrap needed: "
@onready var label = $Label

func _ready():
	label.text = prefix + str(neededScrap)

func fixScrap():
	neededScrap -= 1
	label.text = prefix + str(neededScrap)
	if neededScrap == 0:
		Win()

func Win():
		get_tree().change_scene_to_file("res://scenes/won.tscn")
