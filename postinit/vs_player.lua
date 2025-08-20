-- Common Dependencies.
local _G           = GLOBAL
local require      = _G.require
local EQUIPSLOTS   = _G.EQUIPSLOTS

local EQUIPSLOTS_VANITYSLOTS_INDEX =
{
    [EQUIPSLOTS.HANDS] = 1,
    [EQUIPSLOTS.BODY]  = 2,
    [EQUIPSLOTS.HEAD]  = 3,
}

local function AddVanitySlots(inst)
	local function RemoveVanitySlots(inst)
		local vanitycontainer = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
		
		if vanitycontainer then
			vanitycontainer.components.container:DropEverything()
			vanitycontainer:Remove()
		end
	end
	
	local function CheckVanitySlots(inst, owner)
		local vanitycontainer = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
		
		if not vanitycontainer then
			inst.components.vanityslot:UpdateVanitySlotInventory()
		end
	end
	
	local function SwapToVanityItem(inst, data)
		local vanityslots = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
		-- local vanityitem = vanityslots ~= nil and vanityslots.components.container:GetItemInSlot(EQUIPSLOTS_VANITYSLOTS_INDEX[data.eslot]) or nil
		-- print("VANITY SLOTS: EQUIPSLOTS INDEX:", _G.dumptable(EQUIPSLOTS_VANITYSLOTS_INDEX))
		-- print("VANITY SLOTS:", data.eslot, EQUIPSLOTS_VANITYSLOTS_INDEX[data.eslot], vanityitem)
		local vanityitem1 = vanityslots ~= nil and vanityslots.components.container:GetItemInSlot(1) or nil
		local vanityitem2 = vanityslots ~= nil and vanityslots.components.container:GetItemInSlot(2) or nil
		local vanityitem3 = vanityslots ~= nil and vanityslots.components.container:GetItemInSlot(3) or nil

		if vanityitem1 ~= nil and vanityitem1.components.equippable ~= nil then
			vanityitem1.components.equippable:Unequip(inst)
			vanityitem1.components.equippable:Equip(inst)
			
			if vanityitem1.components.equippable.onequiptomodelfn ~= nil then
				vanityitem1.components.equippable.onequiptomodelfn(vanityitem1, inst)
			end
			
			if data.item ~= nil and data.item.components.equippable ~= nil then
				inst.AnimState:Hide("LANTERN_OVERLAY") -- Special case for lantern.
			end
		end
		
		if vanityitem2 ~= nil and vanityitem2.components.equippable ~= nil then
			vanityitem2.components.equippable:Unequip(inst)
			vanityitem2.components.equippable:Equip(inst)
			
			if vanityitem2.components.equippable.onequiptomodelfn ~= nil then
				vanityitem2.components.equippable.onequiptomodelfn(vanityitem2, inst)
			end
		end
		
		if vanityitem3 ~= nil and vanityitem3.components.equippable ~= nil then
			vanityitem3.components.equippable:Unequip(inst)
			vanityitem3.components.equippable:Equip(inst)
			
			--[[
			if vanityitem3.components.equippable.onequiptomodelfn ~= nil then
				vanityitem3.components.equippable.onequiptomodelfn(vanityitem3, inst)
			end
			]]--
			
			if data.item and data.item.prefab == vanityitem3.prefab then 
				print("VANITY SLOTS: EQUIPPED AND VANITY ITEM ARE THE SAME.")
				print("VANITY SLOTS: YOU SHOULDN'T BE DOING THAT.")
			else
				if vanityitem3.components.equippable.onequiptomodelfn ~= nil then
					vanityitem3.components.equippable.onequiptomodelfn(vanityitem3, inst)
				end
			end
		end
	end
	
	local function SwapToRealItem(inst, data)
		local vanityslots = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
		local vanityitem1 = vanityslots ~= nil and vanityslots.components.container:GetItemInSlot(1) or nil
		local vanityitem2 = vanityslots ~= nil and vanityslots.components.container:GetItemInSlot(2) or nil
		local vanityitem3 = vanityslots ~= nil and vanityslots.components.container:GetItemInSlot(3) or nil

		if vanityitem1 ~= nil and vanityitem1.components.equippable ~= nil then
			vanityitem1.components.equippable:Unequip(inst)
			vanityitem1.components.equippable:Equip(inst)
			
			if vanityitem1.components.equippable.onequiptomodelfn ~= nil then
				vanityitem1.components.equippable.onequiptomodelfn(vanityitem1, inst)
			end
		end
		
		if vanityitem2 ~= nil and vanityitem2.components.equippable ~= nil then
			vanityitem2.components.equippable:Unequip(inst)
			vanityitem2.components.equippable:Equip(inst)
			
			if vanityitem2.components.equippable.onequiptomodelfn ~= nil then
				vanityitem2.components.equippable.onequiptomodelfn(vanityitem2, inst)
			end
		end
		
		if vanityitem3 ~= nil and vanityitem3.components.equippable ~= nil then
			vanityitem3.components.equippable:Unequip(inst)
			vanityitem3.components.equippable:Equip(inst)
			
			if vanityitem3.components.equippable.onequiptomodelfn ~= nil then
				vanityitem3.components.equippable.onequiptomodelfn(vanityitem3, inst)
			end
		end
	end

	inst:AddTag("vanityslotowner")

	if not _G.TheWorld.ismastersim then	
		return inst
	end
	
	inst:AddComponent("vanityslot")
	inst.components.vanityslot.bits = 3
	
	inst.CheckVanitySlots = CheckVanitySlots
	inst:DoTaskInTime(0, CheckVanitySlots)
	
	inst.RemoveVanitySlots = RemoveVanitySlots
	inst:ListenForEvent("death", RemoveVanitySlots)
	
	inst:ListenForEvent("equip", SwapToVanityItem)
	inst:ListenForEvent("unequip", SwapToRealItem)
end

AddPlayerPostInit(AddVanitySlots)