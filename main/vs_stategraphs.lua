-- Common Dependencies.
local _G            = GLOBAL
local require       = _G.require
local ACTIONS       = _G.ACTIONS
local ActionHandler = _G.ActionHandler
local EventHandler  = _G.EventHandler
local EQUIPSLOTS    = _G.EQUIPSLOTS

require("vs_main")

local EQUIPSLOTS_VANITYSLOTS_INDEX = TUNING.EQUIPSLOTS_VANITYSLOTS_INDEX
local INVERTED_EQUIPSLOTS_VANITYSLOTS_INDEX = table.invert(EQUIPSLOTS_VANITYSLOTS_INDEX)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.EQUIPVANITY, function(inst, action)
	return "doshortaction"
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.EQUIPVANITY, function(inst, action)
	return "doshortaction"
end))

local function ActionStatesOnEnter(inst)
	local realitem = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
	local skin_build = realitem ~= nil and realitem:GetSkinBuild() or nil
		
	local vanityslots = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
	local vanityitem = vanityslots ~= nil and vanityslots.components.container:GetItemInSlot(1) or nil
	
	if realitem ~= nil and realitem.components.equippable ~= nil then
		local symbol1 = realitem.symbolname1
		local symbol2 = realitem.symbolname2
		local prefab = realitem.prefab

		if skin_build ~= nil then
			inst:PushEvent("equipskinneditem", realitem:GetSkinName())
			inst.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, symbol1 or "swap_"..prefab, realitem.GUID, symbol2 or "swap_"..prefab)
		else
			inst.AnimState:OverrideSymbol("swap_object", symbol1 or "swap_"..prefab, symbol2 or "swap_"..prefab)
		end
	end
end

local function ActionStatesOnExit(inst)
	local realitem = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
	local vanityslots = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)

	local vanityitem = vanityslots ~= nil and vanityslots.components.container:GetItemInSlot(1) or nil
	local skin_build = vanityitem ~= nil and vanityitem:GetSkinBuild() or nil
				
	if vanityitem ~= nil and vanityitem.components.equippable ~= nil then
		local symbol1 = vanityitem.symbolname1
		local symbol2 = vanityitem.symbolname2
		local prefab = vanityitem.prefab

		if skin_build ~= nil then
			inst:PushEvent("equipskinneditem", vanityitem:GetSkinName())
			inst.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, symbol1 or "swap_"..prefab, realitem.GUID, symbol2 or "swap_"..prefab)
		else
			inst.AnimState:OverrideSymbol("swap_object", symbol1 or "swap_"..prefab, symbol2 or "swap_"..prefab)
		end
	end
end

-- Hack for when player is trying to hide with bush hat but have a vanity item equipped.
AddStategraphPostInit("wilson", function(sg)
	-- Bush Hiding States
	local _hide_onenter = sg.states["hide"].onenter
	local _hide_onexit = sg.states["hide"].onexit
	
	sg.states["hide"].onenter = function(inst)
		local realitem = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
		local skin_build = realitem ~= nil and realitem:GetSkinBuild() or nil
		
		if realitem ~= nil and realitem.components.equippable ~= nil then
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

	end))
	
	sg.states["hide"].onexit = function(inst)
		local vanityslots = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
		local vanityitem = vanityslots ~= nil and vanityslots.components.container:GetItemInSlot(3) or nil
		local skin_build = vanityitem ~= nil and vanityitem:GetSkinBuild() or nil
				
		if vanityitem ~= nil and vanityitem.components.equippable ~= nil then
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
	
	-- Shell Hiding States
	local _shell_enter_onenter = sg.states["shell_enter"].onenter
	local _shell_idle_onenter = sg.states["shell_idle"].onenter
	local _shell_idle_onexit = sg.states["shell_idle"].onexit
	local _shell_hit_onenter = sg.states["shell_hit"].onenter
	
	sg.states["shell_enter"].onenter = function(inst)
		local realitem = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
		local skin_build = realitem ~= nil and realitem:GetSkinBuild() or nil
		
		if realitem ~= nil and realitem.components.equippable ~= nil then
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
	
	-- Weremode States
	local _transform_wereplayer_onenter = sg.states["transform_wereplayer"].onenter
	
	sg.states["transform_wereplayer"].onenter = function(inst, data)
		local vanityslots = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
		-- local vanityitem = vanityslots ~= nil and vanityslots.components.container:GetItemInSlot(EQUIPSLOTS_VANITYSLOTS_INDEX[data.eslot]) or nil
		
		-- I can't seem to get a workaround to hide equipped vanity when transforming
		-- because it messes up the transforming animation and I don't want that.
		if vanityslots ~= nil then
			vanityslots.components.container:DropEverything()
		end

		return _transform_wereplayer_onenter(inst, data)
	end

	for k, modes in pairs(TUNING.VANITY_WEREMODES) do
		local _transform_person_onexit = sg.states["transform_"..modes.."_person"].onexit
		
		sg.states["transform_"..modes.."_person"].onexit = function(inst, data, ...)
			if not (inst.components.health:IsDead() or inst:HasTag("wereplayer")) then
				local vanityslots = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
				-- local vanityitem = vanityslots ~= nil and vanityslots.replica.container:GetItemInSlot(EQUIPSLOTS_VANITYSLOTS_INDEX[data.eslot]) or nil
			
				if vanityslots == nil then
					inst.components.vanityslots:UpdateVanitySlotsInventory()
				end
			end
		
			return _transform_person_onexit(inst, ...)
		end
	end

	-- Action States
	for k, names in pairs(TUNING.VANITY_STATES_ONEXIT) do
		local state = sg.states[names]

		state.onexit = function(inst)
			-- print("VANIY SLOTS: THIS STATE DOES NOT HAVE onexit")
		end
	end
	
	for k, actions in pairs(TUNING.VANITY_STATES_NAMES) do
		local _state_onenter = sg.states[actions].onenter
		local _state_ontimeout = sg.states[actions].ontimeout
		local _state_onexit = sg.states[actions].onexit
		
		sg.states[actions].onenter = function(inst, ...)
			local realitem = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
			local skin_build = realitem ~= nil and realitem:GetSkinBuild() or nil

			local vanityslots = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
			local vanityitem = vanityslots ~= nil and vanityslots.components.container:GetItemInSlot(1) or nil
	
			if realitem ~= nil and realitem.components.equippable ~= nil then
				local symbol1 = realitem.symbolname1
				local symbol2 = realitem.symbolname2
				local prefab = realitem.prefab

				if skin_build ~= nil then
					inst:PushEvent("equipskinneditem", realitem:GetSkinName())
					inst.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, symbol1 or "swap_"..prefab, realitem.GUID, symbol2 or "swap_"..prefab)
				else
					inst.AnimState:OverrideSymbol("swap_object", symbol1 or "swap_"..prefab, symbol2 or "swap_"..prefab)
				end
				
				if realitem:HasTag("vanity_persists_fx") then
					realitem.fx.entity:Show()
				end
			
				if realitem:HasTag("vanity_toggable_fx") then
					realitem.fx:ToggleEquipped(true)
				end
			end
			
			if vanityitem ~= nil and vanityitem:HasTag("vanity_shield") then
				inst.AnimState:ShowSymbol("swap_object")
			end
			
			if vanityitem ~= nil and vanityitem:HasTag("vanity_has_fx") then
				vanityitem.components.equippable:Unequip(inst)
				
				ActionStatesOnEnter(inst)
				
				if vanityitem.onequipvanity ~= nil then
					vanityitem.onequipvanity(vanityitem, inst)
				else
					_G.ApplyVanityEffects(vanityitem, inst)
				end

				_G.ApplyContainerEffects(vanityitem, realitem, inst)
			end
		
			return _state_onenter(inst, ...)
		end
		
		sg.states[actions].onexit = function(inst, ...)
			local realitem = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
			local vanityslots = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)

			local vanityitem = vanityslots ~= nil and vanityslots.components.container:GetItemInSlot(1) or nil
			local skin_build = vanityitem ~= nil and vanityitem:GetSkinBuild() or nil

			--[[
			if vanityitem ~= nil and vanityitem.components.equippable ~= nil then
				local symbol1 = vanityitem.symbolname1
				local symbol2 = vanityitem.symbolname2
				local prefab = vanityitem.prefab

				if skin_build ~= nil then
					inst:PushEvent("equipskinneditem", vanityitem:GetSkinName())
					inst.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, symbol1 or "swap_"..prefab, realitem.GUID, symbol2 or "swap_"..prefab)
				else
					inst.AnimState:OverrideSymbol("swap_object", symbol1 or "swap_"..prefab, symbol2 or "swap_"..prefab)
				end
			end
			]]--
			
			if vanityitem ~= nil then
				vanityitem.components.equippable:Equip(inst)
				
				if vanityitem.onequipvanity ~= nil then
					vanityitem.onequipvanity(vanityitem, inst)
				else
					_G.ApplyVanityEffects(vanityitem, inst)
				end

				_G.ApplyContainerEffects(vanityitem, realitem, inst)
				
				if realitem ~= nil and realitem:HasTag("vanity_persists_fx") then
					if realitem.fx ~= nil then
						realitem.fx.entity:Hide()
					end
				end
			
				if realitem ~= nil and realitem:HasTag("vanity_toggable_fx") then
					if realitem.fx ~= nil then
						realitem.fx:ToggleEquipped(false)
					end
				end
			end
		
			return _state_onexit(inst, ...)
		end
	end
	
	local _pour_ontimeout = sg.states["pour"].ontimeout
	sg.states["pour"].ontimeout = function(inst, ...)
		local vanityslots = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
		local vanityitem = vanityslots ~= nil and vanityslots.components.container:GetItemInSlot(1) or nil
		
		if vanityitem ~= nil then
			inst.sg:GoToState("idle") -- Uh... makes the animation a bit faster...
		else
			return _pour_ontimeout(inst, ...)
		end
	end
	
	local _nabbag_onenter = sg.states["nabbag"].onenter
	sg.states["nabbag"].onenter = function(inst, ...)
		local realitem = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		local skin_build = realitem ~= nil and realitem:GetSkinBuild() or nil
		
		local vanityslots = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
		local vanityitem = vanityslots ~= nil and vanityslots.components.container:GetItemInSlot(1) or nil
		
		if realitem ~= nil and realitem.components.equippable ~= nil then
			local symbol1 = realitem.symbolname1
			local symbol2 = "swap_wortox_nabbag"..realitem.nabbag_size or realitem.symbolname2
			local prefab = realitem.prefab

			if skin_build ~= nil then
				inst:PushEvent("equipskinneditem", realitem:GetSkinName())
				inst.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, symbol1 or "swap_"..prefab, realitem.GUID, symbol2 or "swap_"..prefab)
			else
				inst.AnimState:OverrideSymbol("swap_object", symbol1 or "swap_"..prefab, symbol2 or "swap_"..prefab)
			end
		end
		
		if vanityitem ~= nil and vanityitem:HasTag("vanity_shield") then
			inst.AnimState:ShowSymbol("swap_object")
		end
		
		if vanityitem ~= nil and vanityitem:HasTag("vanity_has_fx") then
			vanityitem.components.equippable:Unequip(inst)
				
			if vanityitem.onequipvanity ~= nil then
				vanityitem.onequipvanity(vanityitem, inst)
			else
				_G.ApplyVanityEffects(vanityitem, inst)
			end

			_G.ApplyContainerEffects(vanityitem, realitem, inst)
		end
		
		return _nabbag_onenter(inst, ...)
	end
	
	sg.states["nabbag"].onexit = function(inst, ...)
		local realitem = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		local vanityslots = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)

		local vanityitem = vanityslots ~= nil and vanityslots.components.container:GetItemInSlot(1) or nil
		local skin_build = vanityitem ~= nil and vanityitem:GetSkinBuild() or nil

		--[[
		if vanityitem ~= nil and vanityitem.components.equippable ~= nil then
			local symbol1 = vanityitem.symbolname1
			local symbol2 = vanityitem.symbolname2
			local prefab = vanityitem.prefab

			if skin_build ~= nil then
				inst:PushEvent("equipskinneditem", vanityitem:GetSkinName())
				inst.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, symbol1 or "swap_"..prefab, realitem.GUID, symbol2 or "swap_"..prefab)
			else
				inst.AnimState:OverrideSymbol("swap_object", symbol1 or "swap_"..prefab, symbol2 or "swap_"..prefab)
			end
		end
		]]--
		
		if vanityitem ~= nil then
			vanityitem.components.equippable:Equip(inst)
				
			if vanityitem.onequipvanity ~= nil then
				vanityitem.onequipvanity(vanityitem, inst)
			else
				_G.ApplyVanityEffects(vanityitem, inst)
			end

			_G.ApplyContainerEffects(vanityitem, realitem, inst)
		end
	end
	
	local _attack_onenter = sg.states["attack"].onenter
	local _attack_onexit = sg.states["attack"].onexit
	
	sg.states["attack"].onenter = function(inst, ...)
		local realitem = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		local skin_build = realitem ~= nil and realitem:GetSkinBuild() or nil
		
		local vanityslots = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
		local vanityitem = vanityslots ~= nil and vanityslots.components.container:GetItemInSlot(1) or nil

		if realitem ~= nil and realitem:HasAnyTag(TUNING.VANITY_ATTACK_TAGS) and realitem.components.equippable ~= nil then
			local symbol1 = realitem.symbolname1
			local symbol2 = realitem.symbolname2
			local prefab = realitem.prefab

			if skin_build ~= nil then
				inst:PushEvent("equipskinneditem", realitem:GetSkinName())
				inst.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, symbol1 or "swap_"..prefab, realitem.GUID, symbol2 or "swap_"..prefab)
			else
				inst.AnimState:OverrideSymbol("swap_object", symbol1 or "swap_"..prefab, symbol2 or "swap_"..prefab)
			end
			
			if realitem:HasTag("vanity_persists_fx") then
				if realitem.fx ~= nil then
					realitem.fx.entity:Show()
				end
			end
			
			if realitem:HasTag("vanity_toggable_fx") then
				if realitem.fx ~= nil then
					realitem.fx:ToggleEquipped(true)
				end
			end
		end
		
		if vanityitem ~= nil and vanityitem:HasTag("vanity_shield") then
			inst.AnimState:ShowSymbol("swap_object")
		end
		
		if vanityitem ~= nil and vanityitem:HasTag("vanity_has_fx") then
			vanityitem.components.equippable:Unequip(inst)

			if vanityitem.onequipvanity ~= nil then
				vanityitem.onequipvanity(vanityitem, inst)
			else
				_G.ApplyVanityEffects(vanityitem, inst)
			end

			_G.ApplyContainerEffects(vanityitem, realitem, inst)
		end
		
		return _attack_onenter(inst, ...)
	end
	
	sg.states["attack"].onexit = function(inst, ...)
		local realitem = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		local vanityslots = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
		local vanityitem = vanityslots ~= nil and vanityslots.components.container:GetItemInSlot(1) or nil
		local skin_build = vanityitem ~= nil and vanityitem:GetSkinBuild() or nil

		--[[
		if vanityitem ~= nil and vanityitem.components.equippable ~= nil then
			local symbol1 = vanityitem.symbolname1
			local symbol2 = vanityitem.symbolname2
			local prefab = vanityitem.prefab

			if skin_build ~= nil then
				inst:PushEvent("equipskinneditem", vanityitem:GetSkinName())
				inst.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, symbol1 or "swap_"..prefab, realitem.GUID, symbol2 or "swap_"..prefab)
			else
				inst.AnimState:OverrideSymbol("swap_object", symbol1 or "swap_"..prefab, symbol2 or "swap_"..prefab)
			end
		end
		]]--
		
		if vanityitem ~= nil then
			vanityitem.components.equippable:Equip(inst)
				
			if vanityitem.onequipvanity ~= nil then
				vanityitem.onequipvanity(vanityitem, inst)
			else
				_G.ApplyVanityEffects(vanityitem, inst)
			end

			_G.ApplyContainerEffects(vanityitem, realitem, inst)
			
			if realitem ~= nil and realitem:HasTag("vanity_persists_fx") then
				if realitem.fx ~= nil then
					realitem.fx.entity:Hide()
				end
			end
		
			if realitem ~= nil and realitem:HasTag("vanity_toggable_fx") then
				if realitem.fx ~= nil then
					realitem.fx:ToggleEquipped(false)
				end
			end
		end
			
		return _attack_onexit(inst, ...)
	end
	
	local telebrella_states =
	{
		"remote_teleport_in",
		"remote_teleport_out",
		"remote_teleport_pre",
	}
	
	for k, actions in pairs(telebrella_states) do
		local _state_onenter = sg.states[actions].onenter
		local _state_onexit = sg.states[actions].onexit
		
		sg.states[actions].onenter = function(inst, ...)
			local realitem = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
			local skin_build = realitem ~= nil and realitem:GetSkinBuild() or nil
			
			local vanityslots = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
			local vanityitem = vanityslots ~= nil and vanityslots.components.container:GetItemInSlot(1) or nil
		
			if realitem ~= nil and realitem.components.equippable ~= nil then
				local symbol1 = realitem.symbolname1
				local symbol2 = realitem.symbolname2
				local prefab = realitem.prefab

				if skin_build ~= nil then
					inst:PushEvent("equipskinneditem", realitem:GetSkinName())
					inst.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, symbol1 or "swap_"..prefab, realitem.GUID, symbol2 or "swap_"..prefab)
				else
					inst.AnimState:OverrideSymbol("swap_object", symbol1 or "swap_"..prefab, symbol2 or "swap_"..prefab)
				end
				
				if realitem:HasTag("vanity_teleporter") then
					realitem.swapfx = _G.SpawnPrefab("winona_telebrella_swap_fx")
					realitem.swapfx.entity:SetParent(inst.entity)
					realitem.swapfx.Follower:FollowSymbol(inst.GUID, "swap_object", nil, nil, nil, true, nil, 0, 19)
					realitem.swapfx.components.highlightchild:SetOwner(inst)

					realitem.swapfx2 = _G.SpawnPrefab("winona_telebrella_swap_fx")
					realitem.swapfx2.entity:SetParent(inst.entity)
					realitem.swapfx2.Follower:FollowSymbol(inst.GUID, "swap_object", nil, nil, nil, true, nil, 19)
					realitem.swapfx2.components.highlightchild:SetOwner(inst)
					realitem.swapfx2.AnimState:PlayAnimation("swap20")
				end
			end
			
			if vanityitem ~= nil and vanityitem:HasTag("vanity_shield") then
				inst.AnimState:ShowSymbol("swap_object")
			end
			
			if vanityitem ~= nil and vanityitem:HasTag("vanity_has_fx") then
				vanityitem.components.equippable:Unequip(inst)
				
				if vanityitem.onequipvanity ~= nil then
					vanityitem.onequipvanity(vanityitem, inst)
				else
					_G.ApplyVanityEffects(vanityitem, inst)
				end

				_G.ApplyContainerEffects(vanityitem, realitem, inst)
			end
		
			return _state_onenter(inst, ...)
		end
		
		sg.states[actions].onexit = function(inst, ...)
			local realitem = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
			local vanityslots = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
			local vanityitem = vanityslots ~= nil and vanityslots.components.container:GetItemInSlot(1) or nil
			local skin_build = vanityitem ~= nil and vanityitem:GetSkinBuild() or nil

			--[[
			if vanityitem ~= nil and vanityitem.components.equippable ~= nil then
				local symbol1 = vanityitem.symbolname1
				local symbol2 = vanityitem.symbolname2
				local prefab = vanityitem.prefab

				if skin_build ~= nil then
					inst:PushEvent("equipskinneditem", vanityitem:GetSkinName())
					inst.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, symbol1 or "swap_"..prefab, realitem.GUID, symbol2 or "swap_"..prefab)
				else
					inst.AnimState:OverrideSymbol("swap_object", symbol1 or "swap_"..prefab, symbol2 or "swap_"..prefab)
				end
			end
			]]--
			
			if vanityitem ~= nil then
				vanityitem.components.equippable:Equip(inst)
				
				if vanityitem.onequipvanity ~= nil then
					vanityitem.onequipvanity(vanityitem, inst)
				else
					_G.ApplyVanityEffects(vanityitem, inst)
				end

				_G.ApplyContainerEffects(vanityitem, realitem, inst)

				if realitem ~= nil and realitem:HasTag("vanity_teleporter") then
					if realitem.swapfx ~= nil then
						realitem.swapfx:Remove()
						realitem.swapfx = nil
					end
				
					if realitem.swapfx2 ~= nil then
						realitem.swapfx2:Remove()
						realitem.swapfx2 = nil
					end
				end
			end
		
			return _state_onexit(inst, ...)
		end
	end
end)