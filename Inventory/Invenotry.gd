extends Resource

class_name Inventory

@export var slots:Array[InvSlot]

func pick_up_item(item:Item) -> bool:
	var slot:InvSlot = InvSlot.new()
	slot.item = item
	
	for index in slots.size():
		if not slots[index]:
			slots[index] = slot
			return true
	return false	

