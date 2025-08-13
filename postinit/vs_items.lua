-- Common Dependencies.
local _G           = GLOBAL
local require      = _G.require
local EQUIPSLOTS   = _G.EQUIPSLOTS

require("vs_tuning")

-- This can techincally make hidden items like Bishop shot, 
-- Rook charge, Ewecus spit, etc. an equippable vanity item. Amazing.
local function MakeVanityItem(inst)
	if inst.eslot == EQUIPSLOTS.HAND then
		inst:AddTag("vanity_hand")
	elseif inst.eslot == EQUIPSLOTS.BODY then
		inst:AddTag("vanity_body")
	elseif inst.eslot == EQUIPSLOTS.HEAD then
		inst:AddTag("vanity_head")
	end
end

AddPrefabPostInitAny(MakeVanityItem)