-- Common Dependencies.
local _G           = GLOBAL
local require      = _G.require
local EQUIPSLOTS   = _G.EQUIPSLOTS

AddPrefabPostInit("trunkvest_winter", function(inst)
	inst:AddTag("vanity_body")
end)

AddPrefabPostInit("minerhat", function(inst)
	inst:AddTag("vanity_head")
end)

AddPrefabPostInit("cane", function(inst)
	inst:AddTag("vanity_hand")
end)