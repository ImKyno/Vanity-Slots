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