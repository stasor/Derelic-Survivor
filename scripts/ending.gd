extends Control

@export var time_played:int = 0
@onready var label = $Label

func _ready():
	#label.text += str(time_played)
	pass

func _on_return_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
