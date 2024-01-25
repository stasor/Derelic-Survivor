extends Resource
class_name Item

enum ItemType {UNKNOWN= -1, FOOD, WATER, SCRAP}

@export var name:String = ""
@export var texture:Texture
@export var type:ItemType
@export var amount:int = 0 # used only in some types
