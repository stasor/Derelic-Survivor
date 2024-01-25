extends Control

const INV_SLOT = preload("res://Inventory/InvSlotUI.tscn")
@onready var ItemBoxes = $ItemBoxes

func ClearSlots():
	for child in ItemBoxes.get_children():
		child.queue_free()

func Populate(inv:Inventory):
	for slot in inv.slots:
		var newSlot = INV_SLOT.instantiate()
		ItemBoxes.add_child(newSlot)
		
		if slot != null:
			newSlot.set_inv_slot(slot)

func set_inventory(inv:Inventory):
	ClearSlots()
	Populate(inv)
