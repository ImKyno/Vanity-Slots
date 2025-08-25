-- Common Dependencies.
local _G            = GLOBAL
local require       = _G.require
local ACTIONS       = _G.ACTIONS
local ActionHandler = _G.ActionHandler
local EQUIPSLOTS    = _G.EQUIPSLOTS

local EQUIPSLOTS_VANITYSLOTS_INDEX =
{
    [EQUIPSLOTS.HANDS] = 1,
    [EQUIPSLOTS.BODY]  = 2,
    [EQUIPSLOTS.HEAD]  = 3,
}

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.EQUIPVANITY, function(inst, action)
	return "doshortaction"
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.EQUIPVANITY, function(inst, action)
	return "doshortaction"
end))

-- Hack for when player is trying to hide with bush hat but have a vanity item equipped.
AddStategraphPostInit("wilson", function(sg)
	local _hide_onenter = sg.states["hide"].onenter
	local _hide_onexit = sg.states["hide"].onexit
	
	sg.states["hide"].onenter = function(inst)
		local realitem = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
		local skin_build = realitem:GetSkinBuild()
		
		local prefab = string.gsub(realitem.prefab, "hat", "")
		
		if realitem ~= nil then
			if skin_build ~= nil then
				inst:PushEvent("equipskinneditem", realitem:GetSkinName())
				inst.AnimState:OverrideItemSkinSymbol("swap_hat", skin_build, "swap_hat", realitem.GUID, "hat_"..prefab)
			else
				inst.AnimState:OverrideSymbol("swap_hat", "hat_"..prefab, "swap_hat")
			end
		end
		
		return _hide_onenter(inst)
	end
	
	sg.states["hide"].onexit = function(inst)
		local vanityslots = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
		local vanityitem = vanityslots ~= nil and vanityslots.components.container:GetItemInSlot(3) or nil

		if vanityitem ~= nil and vanityitem.components.equippable ~= nil then
			vanityitem.components.equippable:Unequip(inst)
			vanityitem.components.equippable:Equip(inst)
		end
		
		return _hide_onexit(inst)
	end
end)