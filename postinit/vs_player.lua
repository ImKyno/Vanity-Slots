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
		local vanityslots = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
		local vanityitem = vanityslots ~= nil and vanityslots.components.container:GetItemInSlot(EQUIPSLOTS_VANITYSLOTS_INDEX[data.eslot]) or nil
		local realitem = data.item
		
		--[[
		if realitem ~= nil and realitem:HasTag("lantern_overlay") then
			inst.AnimState:Hide("LANTERN_OVERLAY")
		end
		]]--
		
		if vanityitem ~= nil and vanityitem.components.equippable ~= nil then
			vanityitem.components.equippable:Unequip(inst)
			vanityitem.components.equippable:Equip(inst)
			
			if realitem and realitem.prefab == vanityitem.prefab then 
				-- print("VANITY SLOTS: EQUIPPED/VANITY ITEM ARE THE SAME.")
				-- print("VANITY SLOTS: YOU SHOULDN'T BE DOING THAT.")
				if vanityitem.onequipvanity ~= nil then
					vanityitem.onequipvanity(vanityitem, vanityslots)
				end
			else
				if vanityitem.onequipvanity ~= nil then
					vanityitem.onequipvanity(vanityitem, inst)
				end
			end
			
			-- "Hide" animated items for client, fx still exists in the server.
			if realitem ~= nil then
				_G.RemoveRealItemsFX(realitem, inst)
			
				if realitem and realitem:HasTag("vanity_shield") and
				vanityitem and not vanityitem:HasTag("vanity_shield") then
					inst.AnimState:ShowSymbol("swap_object")
					inst.AnimState:ClearOverrideSymbol("lantern_overlay")
				end
			
				if realitem ~= nil and realitem.components.container ~= nil then
					realitem.components.container:Open(inst)
				end
			end
			
			_G.ApplyVanityEffects(vanityitem, inst)
		end
	end
	
	local function SwapToRealItem(inst, data)
		local vanityslots = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
		local vanityitem = vanityslots ~= nil and vanityslots.components.container:GetItemInSlot(EQUIPSLOTS_VANITYSLOTS_INDEX[data.eslot]) or nil

		if vanityitem ~= nil and vanityitem.components.equippable ~= nil then	
			vanityitem.components.equippable:Unequip(inst)
			vanityitem.components.equippable:Equip(inst)
			
			if vanityitem.onequipvanity ~= nil then
				vanityitem.onequipvanity(vanityitem, inst)
			end
			
			if realitem and realitem:HasTag("vanity_shield") then
				inst.AnimState:ClearOverrideSymbol("swap_object")
				inst.AnimState:ShowSymbol("lantern_overlay")
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