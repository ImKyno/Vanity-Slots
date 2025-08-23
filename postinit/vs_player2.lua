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

local INVERTED_EQUIPSLOTS_VANITYSLOTS_INDEX = table.invert(EQUIPSLOTS_VANITYSLOTS_INDEX)

local function AddVanitySlots(inst)
	local function RemoveVanitySlots(inst)
		local vanityslots = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
		
		if vanityslots then
			vanityslots.components.container:DropEverything()
			vanityslots:Remove()
		end
	end
	
	local function CheckVanitySlots(inst, owner)
		local vanityslots = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
		
		if not vanityslots then
			inst.components.vanityslots:UpdateVanitySlotsInventory()
		end
	end
	
	local function SwapToVanityItem(inst, data)
		local realitem = data.item
		local vanityslots = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)	
		
		local vanityitem1 = vanityslots ~= nil and vanityslots.components.container:GetItemInSlot(1) or nil
		local vanityitem2 = vanityslots ~= nil and vanityslots.components.container:GetItemInSlot(2) or nil
		local vanityitem3 = vanityslots ~= nil and vanityslots.components.container:GetItemInSlot(3) or nil
		
		if vanityitem1 ~= nil and vanityitem1.components.equippable ~= nil then
			vanityitem1.components.equippable:Unequip(inst)
			vanityitem1.components.equippable:Equip(inst)
			
			if realitem ~= nil and realitem.components.equippable ~= nil then
				inst.AnimState:Hide("LANTERN_OVERLAY") -- Special case for lantern.
			end
			
			if realitem and realitem.prefab == vanityitem1.prefab then 
				print("VANITY SLOTS: EQUIPPED AND VANITY ITEM ARE THE SAME.")
				print("VANITY SLOTS: YOU SHOULDN'T BE DOING THAT.")
				if vanityitem1.onequipvanity ~= nil then
					vanityitem1.onequipvanity(vanityitem1, vanityslots)
				end
			else
				if vanityitem1.onequipvanity ~= nil then
					vanityitem1.onequipvanity(vanityitem1, inst)
				end
			end
		end

		if vanityitem2 ~= nil and vanityitem2.components.equippable ~= nil then
			vanityitem2.components.equippable:Unequip(inst)
			vanityitem2.components.equippable:Equip(inst)
			
			if realitem and realitem.prefab == vanityitem2.prefab then 
				print("VANITY SLOTS: EQUIPPED/VANITY ITEM ARE THE SAME.")
				print("VANITY SLOTS: YOU SHOULDN'T BE DOING THAT.")
				if vanityitem2.onequipvanity ~= nil then
					vanityitem2.onequipvanity(vanityitem2, vanityslots)
				end
			else
				if vanityitem2.onequipvanity ~= nil then
					vanityitem2.onequipvanity(vanityitem2, inst)
				end
			end
		end
		
		if vanityitem3 ~= nil and vanityitem3.components.equippable ~= nil then
			vanityitem3.components.equippable:Unequip(inst)
			vanityitem3.components.equippable:Equip(inst)
			
			if realitem and realitem.prefab == vanityitem3.prefab then 
				print("VANITY SLOTS: EQUIPPED/VANITY ITEM ARE THE SAME.")
				print("VANITY SLOTS: YOU SHOULDN'T BE DOING THAT.")
				if vanityitem3.onequipvanity ~= nil then
					vanityitem3.onequipvanity(vanityitem3, vanityslots)
				end
			else
				if vanityitem3.onequipvanity ~= nil then
					vanityitem3.onequipvanity(vanityitem3, inst)
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
			
			if vanityitem1.onequipvanity ~= nil then
				vanityitem1.onequipvanity(vanityitem1, inst)
			end
		end
		
		if vanityitem2 ~= nil and vanityitem2.components.equippable ~= nil then
			vanityitem2.components.equippable:Unequip(inst)
			vanityitem2.components.equippable:Equip(inst)
			
			if vanityitem2.onequipvanity ~= nil then
				vanityitem2.onequipvanity(vanityitem2, inst)
			end
		end
		
		if vanityitem3 ~= nil and vanityitem3.components.equippable ~= nil then
			vanityitem3.components.equippable:Unequip(inst)
			vanityitem3.components.equippable:Equip(inst)
			
			if vanityitem3.onequipvanity ~= nil then
				vanityitem3.onequipvanity(vanityitem3, inst)
			end
		end
	end

	inst:AddTag("vanityslotsowner")

	if not _G.TheWorld.ismastersim then	
		return inst
	end
	
	inst:AddComponent("vanityslots")
	inst.components.vanityslots.bits = 3
	
	inst.RemoveVanitySlots = RemoveVanitySlots
	inst:ListenForEvent("death", RemoveVanitySlots)
	
	inst.CheckVanitySlots = CheckVanitySlots
	inst:DoTaskInTime(0, CheckVanitySlots)
	
	inst:ListenForEvent("equip", SwapToVanityItem)
	inst:ListenForEvent("unequip", SwapToRealItem)
end

AddPlayerPostInit(AddVanitySlots)