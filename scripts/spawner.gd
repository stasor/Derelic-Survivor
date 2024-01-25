extends Control

@export var FoodItems:int = 0
@export var WaterItems:int = 0
@export var ScrapItems:int = 0

const FISH = preload("res://Inventory/Items/Fish.tres")
const SCRAP = preload("res://Inventory/Items/Scrap.tres")
const WATER = preload("res://Inventory/Items/Water.tres")
const ITEM = preload("res://scenes/item.tscn")

@onready var spawner = $"area"
var spawnArea:Rect2
var history:Array[Vector2]

# Called when the node enters the scene tree for the first time.
func _ready():
	spawnArea = spawner.get_rect()
	print(spawnArea)
	#spawnArea.positionf =- spawner.anchor
	while FoodItems > 0:
		spawn(FISH)
		FoodItems -= 1
	while WaterItems > 0:
		spawn(WATER)
		WaterItems -= 1
	while ScrapItems > 0:
		spawn(SCRAP)
		ScrapItems -= 1
	

func random_pos() -> Vector2:
	var x = randi_range(spawnArea.position.x, spawnArea.end.x)
	var y = randi_range(spawnArea.position.y, spawnArea.end.y)
	var vec = Vector2(x, y)
	
	if history.has(vec) and spawnArea.get_area() < history.size():
		vec = random_pos() #call this function until we generate a unique vector2
	history.append(vec)
	return vec

func spawn(item:Item):
		var pos = random_pos()
		var toSpawn = ITEM.instantiate()
		toSpawn.item = item
		toSpawn.set_position(pos)
		add_child(toSpawn)
