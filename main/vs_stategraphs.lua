-- Common Dependencies.
local _G            = GLOBAL
local require       = _G.require
local ACTIONS       = _G.ACTIONS
local ActionHandler = _G.ActionHandler
local EventHandler  = _G.EventHandler
local EQUIPSLOTS    = _G.EQUIPSLOTS

require("vs_main")

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
	-- Bush Hiding State
	local _hide_onenter = sg.states["hide"].onenter
	local _hide_onexit = sg.states["hide"].onexit
	
	sg.states["hide"].onenter = function(inst)
		local realitem = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
		local skin_build = realitem ~= nil and realitem:GetSkinBuild() or nil
		
		if realitem ~= nil and realitem.components.equippable ~= nil then
			-- local prefab = string.gsub(realitem.prefab, "hat", "")
			local prefab = realitem.symbolname or string.gsub(realitem.prefab, "hat", "")
			
			if skin_build ~= nil then
				inst:PushEvent("equipskinneditem", realitem:GetSkinName())
				inst.AnimState:OverrideItemSkinSymbol("swap_hat", skin_build, "swap_hat", realitem.GUID, "hat_"..prefab)
			else
				inst.AnimState:OverrideSymbol("swap_hat", "hat_"..prefab, "swap_hat")
			end
		end
		
		return _hide_onenter(inst)
	end
	
	table.insert(sg.states["hide"].events, EventHandler("equip", function(inst)
		-- print("VANITY SLOTS: ITEM WAS EQUIPPED")
	end))
	
	sg.states["hide"].onexit = function(inst)
		local vanityslots = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
		local vanityitem = vanityslots ~= nil and vanityslots.components.container:GetItemInSlot(3) or nil
		local skin_build = vanityitem ~= nil and vanityitem:GetSkinBuild() or nil
				
		if vanityitem ~= nil and vanityitem.components.equippable ~= nil then
			-- local prefab = string.gsub(vanityitem.prefab, "hat", "")
			local prefab = vanityitem.symbolname or string.gsub(vanityitem.prefab, "hat", "")
			
			if skin_build ~= nil then
				inst:PushEvent("equipskinneditem", vanityitem:GetSkinName())
				inst.AnimState:OverrideItemSkinSymbol("swap_hat", skin_build, "swap_hat", vanityitem.GUID, "hat_"..prefab)
			else
				inst.AnimState:OverrideSymbol("swap_hat", "hat_"..prefab, "swap_hat")
			end
		end
		
		return _hide_onexit(inst)
	end
	
	-- Shell Hiding State
	local _shell_enter_onenter = sg.states["shell_enter"].onenter
	local _shell_idle_onenter = sg.states["shell_idle"].onenter
	local _shell_idle_onexit = sg.states["shell_idle"].onexit
	local _shell_hit_onenter = sg.states["shell_hit"].onenter
	
	sg.states["shell_enter"].onenter = function(inst)
		local realitem = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
		local skin_build = realitem ~= nil and realitem:GetSkinBuild() or nil
		
		if realitem ~= nil and realitem.components.equippable ~= nil then
			-- local prefab = realitem.symbolname or realitem.prefab
			local prefab = realitem.AnimState:GetBuild() or realitem.prefab

			if skin_build ~= nil then
				inst:PushEvent("equipskinneditem", realitem:GetSkinName())
				inst.AnimState:OverrideItemSkinSymbol("swap_body_tall", skin_build, "swap_body_tall", realitem.GUID, prefab)
			else
				inst.AnimState:OverrideSymbol("swap_body_tall", prefab, "swap_body_tall")
			end
		end
		
		return _shell_enter_onenter(inst)
	end
	
	sg.states["shell_idle"].onenter = function(inst)
		local realitem = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
		local skin_build = realitem ~= nil and realitem:GetSkinBuild() or nil
		
		if realitem ~= nil and realitem.components.equippable ~= nil then
			-- local prefab = realitem.symbolname or realitem.prefab
			local prefab = realitem.AnimState:GetBuild() or realitem.prefab

			if skin_build ~= nil then
				inst:PushEvent("equipskinneditem", realitem:GetSkinName())
				inst.AnimState:OverrideItemSkinSymbol("swap_body_tall", skin_build, "swap_body_tall", realitem.GUID, prefab)
			else
				inst.AnimState:OverrideSymbol("swap_body_tall", prefab, "swap_body_tall")
			end
		end
		
		return _shell_idle_onenter(inst)
	end
	
	sg.states["shell_idle"].onexit = function(inst)
		local vanityslots = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
		local vanityitem = vanityslots ~= nil and vanityslots.components.container:GetItemInSlot(2) or nil
		local skin_build = vanityitem ~= nil and vanityitem:GetSkinBuild() or nil
				
		if vanityitem ~= nil and vanityitem.components.equippable ~= nil then
			-- local prefab = vanityitem.symbolname or vanityitem.prefab
			local prefab = vanityitem.AnimState:GetBuild() or vanityitem.prefab

			if skin_build ~= nil then
				inst:PushEvent("equipskinneditem", vanityitem:GetSkinName())
				inst.AnimState:OverrideItemSkinSymbol("swap_body_tall", skin_build, "swap_body_tall", vanityitem.GUID, prefab)
			else
				inst.AnimState:OverrideSymbol("swap_body_tall", prefab, "swap_body_tall")
			end
		end
		
		return _shell_idle_onexit(inst)
	end
	
	sg.states["shell_hit"].onenter = function(inst)
		local realitem = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
		local skin_build = realitem ~= nil and realitem:GetSkinBuild() or nil
		
		if realitem ~= nil and realitem.components.equippable ~= nil then
			-- local prefab = realitem.symbolname or realitem.prefab
			local prefab = realitem.AnimState:GetBuild() or realitem.prefab

			if skin_build ~= nil then
				inst:PushEvent("equipskinneditem", realitem:GetSkinName())
				inst.AnimState:OverrideItemSkinSymbol("swap_body_tall", skin_build, "swap_body_tall", realitem.GUID, prefab)
			else
				inst.AnimState:OverrideSymbol("swap_body_tall", prefab, "swap_body_tall")
			end
		end
		
		return _shell_hit_onenter(inst)
	end
end)
