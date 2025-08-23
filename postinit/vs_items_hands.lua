-- Common Dependencies.
local _G           = GLOBAL
local require      = _G.require
local EQUIPSLOTS   = _G.EQUIPSLOTS

require("vs_tuning")

local function LanternPostInit(inst)
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			if inst.components.fueled ~= nil then
				inst.components.fueled:StopConsuming()
				inst.components.fueled.accepting = false
			end
			
			owner.AnimState:Hide("LANTERN_OVERLAY")
		end
	end
	
	inst.onunequipvanity = function(inst, owner)
		if owner ~= nil then
			if inst.components.fueled ~= nil then
				inst.components.fueled.accepting = true
				
				if inst.components.equippable:IsEquipped() then
					inst.components.fueled:StartConsuming()
					owner.AnimState:Show("LANTERN_OVERLAY")
				end
			end
		end
	end
end

AddPrefabPostInit("lantern", LanternPostInit)