




-- Searches for oxygen source recursively. If item has its own inventory - it will be searched.
function stop_right_there_criminal_scum.FindRecursively(container, iter, tbl)
    if container.OwnInventory == nil then
        return
    end
	
	--get local items
	for item in container.OwnInventory.AllItems do
		if item.Illegitimate then
            table.insert(tbl, iter, item)
            iter = iter + 1
        end
    end
	
	--get items in inventories
	for item in container.OwnInventory.AllItems do
        if item.OwnInventory ~= nil then
            stop_right_there_criminal_scum.FindRecursively(item, iter, tbl)
		end
	end
		
	
	
	
	--get the local tanks first
    --for item in itemList do
        --if item.HasTag("oxygensource") then
        --    table.insert(tbl, iter, item)
        --    iter = iter + 1
        --end
    --end
	
	--second loop
    --for item in itemList do
		--second loop causes problems somehow
    --end
	
	--then recursively get the contained tanks
	--for item in itemList do
        --if item.OwnInventory ~= nil then
		--	local containersInventory = item.OwnInventory.AllItems
        --    AutoReload.FindRecursively(containersInventory, iter, tbl)
        --end
    --end

end



function stop_right_there_criminal_scum.collect_all_stolen_items_from_character(character)
    local stolen_items = {}
    local iter = 1

	

	-- Collect all stolen_items from player's inventory
    for item in character.Inventory.AllItems do

        if item.Illegitimate then
            table.insert(stolen_items, iter, item)
            iter = iter + 1
        end
	end
	
	-- then recursively get stolen_items from anything with an inventory
	for item in character.Inventory.AllItems do
        if item.OwnInventory ~= nil then
            stop_right_there_criminal_scum.FindRecursively(item, iter, stolen_items)
        end
    end
	

    return stolen_items
end





function stop_right_there_criminal_scum.recursively_find_first_open_slot(inventory_to_check, stolen_item)
    local slot_index = inventory_to_check.FindAllowedSlot(stolen_item, false)
    if slot_index ~= -1 then 
        return inventory_to_check, slot_index 
    end
    
    -- then recursively get stolen_items from anything with an inventory
    for item in inventory_to_check.AllItems do
        if item.OwnInventory ~= nil then
            local sub_inventory, sub_slot_index = stop_right_there_criminal_scum.recursively_find_first_open_slot(item.OwnInventory, stolen_item)
            if sub_inventory ~= nil then
                return sub_inventory, sub_slot_index
            end
        end
    end
    
    return nil, -1
end



