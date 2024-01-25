extends PanelContainer

@onready var texture_rect = $MarginContainer/TextureRect

func set_inv_slot(slot:InvSlot):
	texture_rect.texture = slot.item.texture
	
