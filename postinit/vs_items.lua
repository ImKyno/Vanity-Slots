-- Common Dependencies.
local _G           = GLOBAL
local require      = _G.require
local EQUIPSLOTS   = _G.EQUIPSLOTS

require("vs_tuning")

for slot, item in pairs(TUNING.VANITYSLOT_HAND) do
	AddPrefabPostInit(item, function(inst)
		inst:AddTag("vanity_hand")
	end)
end

for slot, item in pairs(TUNING.VANITYSLOT_BODY) do
	AddPrefabPostInit(item, function(inst)
		inst:AddTag("vanity_body")
	end)
end

for slot, item in pairs(TUNING.VANITYSLOT_HEAD) do
	AddPrefabPostInit(item, function(inst)
		inst:AddTag("vanity_head")
	end)
end