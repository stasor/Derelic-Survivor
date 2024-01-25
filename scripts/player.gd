extends CharacterBody2D

#TODO time till lose
#TODO Find assets for items and shuttle
#TODO lose menu
#TODO win menu
#TODO random item generation

@export var inventory:Inventory

const SPEED = 130.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# all the local nodes that are going to be used
@onready var hungerBar:ProgressBar = get_node("Camera2D/GUI/TopLeft/Bars/Hunger")
@onready var thirstBar:ProgressBar = get_node("Camera2D/GUI/TopLeft/Bars/Thirst")
@onready var pickUpArea:Area2D = $PickUpArea
@onready var interactArea:Area2D = $InteractArea
#const WorldItemScene = preload("res://scenes/item.tscn")
#const WorldItem = preload("res://scripts/worldItemScene.gd")
var anim = null

@onready var start_time = Time

@onready var player_inventory = $Camera2D/GUI/PlayerInventory

func _ready():
	player_inventory.set_inventory(inventory)
	anim = get_node("AnimatedSprite2D")
	Animation(Vector2(0,0))

# called roughly a the same time, from  per frame call for physics processing
func _physics_process(delta): 
	var direction = Get_direction()
	velocity = direction * SPEED
	move_and_slide()
	Animation(direction)

# the direction of 2d movement based on key input
func Get_direction() -> Vector2:
	var direction = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("ui_right"):
		direction.x = 1
	if Input.is_action_pressed("ui_left"):
		direction.x = -1
	if Input.is_action_pressed("ui_down"):
		direction.y = 1
	if Input.is_action_pressed("ui_up"):
		direction.y = -1
	return direction.normalized() # normalized so sideways movement dosent equal 2x speed 

func Animation(direction): # runs the animation corresponding to the movement direction
	var animation = null
	if direction.x != 0:
		animation = "walk_right" if direction.x > 0 else "walk_left"
	elif direction.y != 0:
		animation = "walk_down" if direction.y > 0 else "walk_up"
	else:
		if anim.animation != null and anim.animation != "sit_down":
			animation = "sit_down"
	
	if animation != null:
		anim.play(animation)

#TODO Array custom sorting 
func Nearest_Item(list:Array[Area2D]) -> Area2D:
	 # Initialize these as null for the first Area2d in the arrayt
	var minDistance
	var minDistanceObject
	for item in list:
		var distance = self.position.distance_to(item.position)
		
		if not minDistanceObject:
			minDistance = distance
			minDistanceObject = item
			continue
		
		if distance < minDistance:
			minDistance = distance
			minDistanceObject = item
	
	return minDistanceObject

func useItem(itemNum:int):
	var item:Item
	if inventory.slots[itemNum] != null:
		item = inventory.slots[itemNum].item
	else: return
	
	match item.type:
		Item.ItemType.FOOD:
			Eat(item.amount)
		Item.ItemType.WATER:
			Drink(item.amount )
		Item.ItemType.SCRAP:
			if interactArea.has_overlapping_areas():
				var place = Nearest_Item(interactArea.get_overlapping_areas())
				place.fixScrap()
			else: return
	
	inventory.slots[itemNum] = null
	player_inventory.set_inventory(inventory)

func _input(event):
	if not event is InputEventKey:
		return
	
	if event.is_action_pressed("pickup_item"):
		if pickUpArea.has_overlapping_areas():
			var interactable = Nearest_Item(pickUpArea.get_overlapping_areas())
			
			#if interactable.get("name") is WorldItem.name:
			if interactable.item != null: 
				var item:Item = interactable.item
				if inventory.pick_up_item(item):
					player_inventory.set_inventory(inventory)
					interactable.queue_free()
					return
			
	
	if  range(KEY_1, OS.find_keycode_from_string(str(inventory.slots.size())) +1).has(event.keycode): #Easiest way to get if a key the size of the inventory is presed e.g. 1 to 3
		useItem(event.keycode - KEY_1) # transform keycode to int from 0 
	

func Drink(amount:int):
	thirstBar.value += amount

func Eat(amount:int):
	hungerBar.value += amount

func _on_thirst_timer_timeout():
	thirstBar.value -= 1

func _on_hunger_timer_timeout():
	hungerBar.value -= 1

func _on_hunger_value_changed(value):
	if value == hungerBar.min_value:
		Lose()

func _on_thirst_value_changed(value):
	if value == thirstBar.min_value:
		Lose()

func _on_ship_destroyed_timer_timeout():
	Lose()
func Lose():
	#const Lost = preload("res://scripts/lost.gd")
	#Lost.time_played = $Camera2D/GUI/ShipDestroyedTimer.get
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
