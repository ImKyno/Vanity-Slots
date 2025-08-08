-- Common Dependencies.
local _G           = GLOBAL
local require      = _G.require
local EQUIPSLOTS   = _G.EQUIPSLOTS

local function AddVanitySlots(inst)
	local function RemoveVanitySlots(inst)
		local vanitycontainer = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
		
		if vanitycontainer then
			vanitycontainer.components.container:DropEverything()
			vanitycontainer:Remove()
		end
	end
	
	local function CheckVanitySlots(inst)
		local vanitycontainer = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
		
		if not vanitycontainer then
			local newcontainer = _G.SpawnPrefab("vanity_slots")
			inst.components.inventory:Equip(newcontainer)
		end
	end
	
	inst:AddTag("vanityslotowner")

	if not _G.TheWorld.ismastersim then	
		return inst
	end
	
	inst:AddComponent("vanityslot")
	
	inst.CheckVanitySlots = CheckVanitySlots
	inst:DoTaskInTime(0, CheckVanitySlots)
	
	inst.RemoveVanitySlots = RemoveVanitySlots
	inst:ListenForEvent("death", RemoveVanitySlots)
end

AddPlayerPostInit(AddVanitySlots)

AddPrefabPostInit("trunkvest_winter", function(inst)
	inst:AddTag("vanity_body")
end)

AddPrefabPostInit("minerhat", function(inst)
	inst:AddTag("vanity_head")
end)

AddPrefabPostInit("cane", function(inst)
	inst:AddTag("vanity_hand")
end)

--[[
-- We are making clothes and hats have 2 dedicated slots... HUGE MISTAKE!
local function MakeVanitySlots(inst)
	local function ConvertBodySlot(inst)
		if inst.components.equippable ~= nil then
			inst.components.equippable.equipslot = {"body", "vanity_body"}
		end
	end

	local function ConvertHeadSlot(inst)
		if inst.components.equippable ~= nil then
			inst.components.equippable.equipslot = {"head", "vanity_head"}
		end
	end
	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.equippable ~= nil then
		if inst.components.equippable.equipslot == EQUIPSLOTS.BODY then
			ConvertBodySlot(inst)
		elseif inst.components.equippable.equipslot == EQUIPSLOTS.HEAD then
			ConvertHeadSlot(inst)
		end
	end
end

AddPrefabPostInitAny(MakeVanitySlots)
]]--