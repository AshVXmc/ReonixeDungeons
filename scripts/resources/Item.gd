extends Resource

export(String) var item_id # use to identify the item
export(String) var item_name # can be changed for flavor
export(String) var item_description 
export(Texture) var item_texture


func _init(p_item_id = null, p_item_name = null, p_item_description = null, p_item_texture = null):
	item_id = p_item_id
	item_name = p_item_name
	item_description = p_item_description
	item_texture = p_item_texture
