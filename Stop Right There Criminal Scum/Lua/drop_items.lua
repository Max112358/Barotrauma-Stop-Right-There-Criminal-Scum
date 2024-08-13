if SERVER then return end --prevents it from running on the server



function stop_right_there_criminal_scum.drop_items_if_button_pushed()
    if Character.Controlled == nil then return end
	
    local stolen_items = stop_right_there_criminal_scum.collect_all_stolen_items_from_character(Character.Controlled)
	
	
	
	for stolen_item in stolen_items do
		local skip_rest = false
		
		--local itemIndex = stolen_item.ParentInventory.FindIndex(stolen_item)
		-- Add opened container such as locker
		local openedContainer = Character.Controlled.SelectedItem
		if openedContainer ~= nil then
			--if you have opened a locker, try to put it in there
			--openedContainer.OwnInventory.TryPutItem(stolen_item, itemIndex, true, false, Character.Controlled)
			
			--print(openedContainer.OwnInventory.EmptySlotCount) --this is actually full slot count. not sure why its named this
			
			local num_slots_available =  openedContainer.OwnInventory.Capacity - openedContainer.OwnInventory.EmptySlotCount
			
			
			--local prefab_to_check = stolen_item.Prefab
			--local how_many_can_be_put = openedContainer.OwnInventory.HowManyCanBePut(prefab_to_check, stolen_item.Condition)
			
			--print(num_slots_available)
			
			--slot_index = openedContainer.OwnInventory.FindAllowedSlot(stolen_item, false)
			
			
			local inventory_to_store_it_in, slot_index = stop_right_there_criminal_scum.recursively_find_first_open_slot(openedContainer.OwnInventory, stolen_item)
			
			--print("slot index " .. tostring(slot_index))
			if slot_index ~= -1 then
			
				if stolen_item.ParentInventory ~= Character.Controlled.Inventory then
					--the item is inside an inventory that isnt the player
					--print(stolen_item.ParentInventory.Owner)
					if stolen_item.ParentInventory.Owner.Illegitimate == false then
						--drop the item only if the container its in is legit. If that was also stolen, just transfer that instead (on some other iteration)
						inventory_to_store_it_in.TryPutItem(stolen_item, slot_index, false, false, Character.Controlled, true, true)
						skip_rest = true  -- This replaces the desired 'continue'
					end
				else
					--the item is inside the players base inventory
					inventory_to_store_it_in.TryPutItem(stolen_item, slot_index, false, false, Character.Controlled, true, true)
					skip_rest = true  -- This replaces the desired 'continue'
				end
			end
		end
		--]]
		
		--if we couldnt find a home for it, just drop it on the floor
		if not skip_rest then
			if stolen_item.ParentInventory ~= Character.Controlled.Inventory then
				--the item is inside an inventory that isnt the player
				--print(stolen_item.ParentInventory.Owner)
				if stolen_item.ParentInventory.Owner.Illegitimate == false then
					--drop the item only if the container its in is legit. If that was also stolen, just drop that instead (on some other iteration)
					stolen_item.Drop(Character.Controlled, true, true)
				end
			else
				--the item is inside the players base inventory
				stolen_item.Drop(Character.Controlled, true, true)
			end
		end
		
	end
	
end




Hook.Add("keyUpdate", "push_button_to_drop_stolen_items", function (keyargs)
    if Character.DisableControls then return end
    if not PlayerInput.KeyDown(stop_right_there_criminal_scum.drop_stolen_item_key) then return end
    
	
	
	stop_right_there_criminal_scum.drop_items_if_button_pushed()
	
end)