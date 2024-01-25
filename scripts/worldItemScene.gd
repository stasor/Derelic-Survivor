extends Area2D

@export var item:Item

# Called when the node enters the scene tree for the first time.
func _ready():
	var sprite = $Sprite2D
	sprite.texture = item.texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

