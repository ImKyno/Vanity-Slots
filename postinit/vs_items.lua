-- Common Dependencies.
local _G           = GLOBAL
local require      = _G.require
local EQUIPSLOTS   = _G.EQUIPSLOTS

require("vs_tuning")

-- This can techincally make hidden items like Bishop shot, 
-- Rook charge, Ewecus spit, etc. an equippable vanity item. Amazing!
local function MakeVanityItem(inst)
	local equippable = inst.replica.equippable
	
	if equippable ~= nil then
		local eslot = equippable:EquipSlot()
		
		if eslot == EQUIPSLOTS.HANDS then
			inst:AddTag("vanity_hand")
		elseif eslot == EQUIPSLOTS.BODY then
			inst:AddTag("vanity_body")
		elseif eslot == EQUIPSLOTS.HEAD then
			-- Not really necessary as hats already have consistent tag "hat".
			-- Still, will make this tag in case some mod needs it.
			inst:AddTag("vanity_head")
		end
	end
end

AddPrefabPostInitAny(MakeVanityItem)

local function OnEquipToModelCommon(inst, owner)

end