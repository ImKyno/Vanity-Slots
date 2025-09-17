-- Common Dependencies.
local _G           = GLOBAL
local require      = _G.require
local EQUIPSLOTS   = _G.EQUIPSLOTS

-- Extra Equip Slots Mods.
-- I'll not be providing further support for it since each mod
-- despite looking identical, they might be different code-wise
-- and this can lead to issues. This is a very simple compatibility patch.
local function MakeVanityItemEES(inst)
	local equippable = inst.replica.equippable
	
	if equippable ~= nil then
		local eslot = equippable:EquipSlot()
		
		if eslot == EQUIPSLOTS.AMULET then
			inst:AddTag("vanity_body")
		elseif eslot == EQUIPSLOTS.BELLY then
			inst:AddTag("vanity_body")
		elseif eslot == EQUIPSLOTS.BACK then
			inst:AddTag("vanity_body")
		elseif eslot == EQUIPSLOTS.NECK then
			inst:AddTag("vanity_body")
		elseif eslot == EQUIPSLOTS.CROWN then
			inst:AddTag("vanity_head")
		end

		inst:AddTag("vanity_item")
	end
end

AddPrefabPostInitAny(MakeVanityItemEES)

-- If other Mods does not set a slot for us it will return EQUIPSLOTS.BODY.
for slot, id in pairs(EQUIPSLOTS) do
    if TUNING.EQUIPSLOTS_VANITYSLOTS_INDEX[slot] == nil then
         TUNING.EQUIPSLOTS_VANITYSLOTS_INDEX[slot] = 2
    end
end

-- Manual slot checks for some mods.
if EQUIPSLOTS.CROWN ~= nil then
	TUNING.EQUIPSLOTS_VANITYSLOTS_INDEX[EQUIPSLOTS.CROWN] = 3
end

--[[
for mod, id in pairs(TUNING.VANITY_EXTRA_EQUIP_SLOTS_MODS) do
	if _G.KnownModIndex:IsModEnabled("workshop-"..id) then
		AddPrefabPostInitAny(MakeVanityItemEES)
		
		-- I'm trying to guess which mod has which EQUIPSLOTS...
		-- If the mod is not listed it will need to manually assign a slot.
		if EQUIPSLOTS.AMULET ~= nil then
			TUNING.EQUIPSLOTS_VANITYSLOTS_INDEX[EQUIPSLOTS.AMULET] = 2
		end
		
		if EQUIPSLOTS.BACK ~= nil then
			TUNING.EQUIPSLOTS_VANITYSLOTS_INDEX[EQUIPSLOTS.BACK] = 2
		end
		
		if EQUIPSLOTS.BELLY ~= nil then
			TUNING.EQUIPSLOTS_VANITYSLOTS_INDEX[EQUIPSLOTS.BELLY] = 2
		end
		
		if EQUIPSLOTS.NECK ~= nil then
			TUNING.EQUIPSLOTS_VANITYSLOTS_INDEX[EQUIPSLOTS.NECK] = 2
		end
		
		if EQUIPSLOTS.CROWN ~= nil then
			TUNING.EQUIPSLOTS_VANITYSLOTS_INDEX[EQUIPSLOTS.CROWN] = 3
		end
	end
end
]]--