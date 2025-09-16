-- Initialize all the needed stuff.
require("vs_constants")
require("vs_containers")
require("vs_tuning")
require("vs_upvaluehacker")
require("strings/vs_strings")

-- This is not for BODY, its for the back part used in Snurtle Shell and other items.
global("ReEquipVanityItemBodyTall")
ReEquipVanityItemBodyTall = function(vanityitem, owner)
	if vanityitem == nil then
		return
	end

	local realitem = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
	local skin_build = realitem:GetSkinBuild()
		
	if realitem ~= nil then
		-- local prefab = realitem.symbolname or realitem.prefab
		local prefab = realitem.AnimState:GetBuild() or realitem.prefab

		if skin_build ~= nil then
			owner:PushEvent("equipskinneditem", realitem:GetSkinName())
			owner.AnimState:OverrideItemSkinSymbol("swap_body_tall", skin_build, "swap_body_tall", realitem.GUID, prefab)
		else
			owner.AnimState:OverrideSymbol("swap_body_tall", prefab, "swap_body_tall")
		end
	end
end

-- Issues when vanity item is equipped when hiding.
global("ReEquipVanityItemHead")
ReEquipVanityItemHead = function(vanityitem, owner)
	if vanityitem == nil then
		return
	end

	local realitem = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
	local skin_build = realitem:GetSkinBuild()
		
	if realitem ~= nil then
		-- local prefab = string.gsub(realitem.prefab, "hat", "")
		local prefab = realitem.symbolname or string.gsub(realitem.prefab, "hat", "")

		if skin_build ~= nil then
			owner:PushEvent("equipskinneditem", realitem:GetSkinName())
			owner.AnimState:OverrideItemSkinSymbol("swap_hat", skin_build, "swap_hat", realitem.GUID, "hat_"..prefab)
		else
			owner.AnimState:OverrideSymbol("swap_hat", "hat_"..prefab, "swap_hat")
		end
	end
end

-- Applies common effects to vanity items.
global("ApplyVanityEffects")
ApplyVanityEffects = function(vanityitem, owner)
	if vanityitem == nil then
		return -- print("VANITY SLOTS: COULDN'T APPLY VANITY EFFECTS")
	end
	
	if vanityitem ~= nil then
		if not vanityitem:HasTag("vanity_equipped") then
			vanityitem:AddTag("vanity_equipped")
		end
	
		if vanityitem.onequipvanity ~= nil then
			vanityitem.onequipvanity(vanityitem, owner)
		else
			-- print("VANITY SLOTS: ITEM WITHOUT \"onequipvanity\" EQUIPPED.")
			-- print("VANITY SLOTS: LIKELY A MODDED ITEM.")
			-- print("VANITY SLOTS: APPLYING DEFAULT VANITY EFFECTS.")
				
			if vanityitem.components.fueled ~= nil then
				vanityitem.components.fueled:StopConsuming()
				
				if vanityitem.components.fueled.accepting ~= nil then
					vanityitem.components.fueled.__accepting = vanityitem.components.fueled.accepting
					vanityitem.components.fueled.accepting = false
				end
				
				if vanityitem.components.fueled.no_sewing ~= nil then
					vanityitem.components.fueled.__no_sewing = vanityitem.components.fueled.no_sewing
					vanityitem.components.fueled.no_sewing = true
				end
			end
			
			if vanityitem.components.perishable ~= nil then
				vanityitem.components.perishable:StopPerishing()
			end
		end

		-- Case where vanity item is equipped when hiding.
		local statename = owner.sg.currentstate.name
		if statename == "hide" then
			ReEquipVanityItemHead(vanityitem, owner)
		end

		if statename == "shell_idle" or statename == "shell_hit" then
			ReEquipVanityItemBodyTall(vanityitem, owner)
		end
	end
end

-- Removes common effects from vanity items.
global("RemoveVanityEffects")
RemoveVanityEffects = function(vanityitem, owner)
	if vanityitem == nil then
		return -- print("VANITY SLOTS: COULDN'T REMOVE VANITY EFFECTS")
	end

	if vanityitem ~= nil then
		if vanityitem:HasTag("vanity_equipped") then
			vanityitem:RemoveTag("vanity_equipped")
		end

		if vanityitem.onunequipvanity ~= nil then
			vanityitem.onunequipvanity(vanityitem, owner)
		else
			-- print("VANITY SLOTS: ITEM WITHOUT \"onunequipvanity\" EQUIPPED.")
			-- print("VANITY SLOTS: LIKELY A MODDED ITEM.")
			-- print("VANITY SLOTS: REMOVING DEFAULT VANITY EFFECTS.")

			if vanityitem.components.fueled ~= nil then
				if vanityitem.components.equippable:IsEquipped() then
					vanityitem.components.fueled:StartConsuming()
				end

				if vanityitem.components.fueled.accepting ~= nil then
					vanityitem.components.fueled.accepting = vanityitem.components.fueled.__accepting
				end

				if vanityitem.components.fueled.no_sewing ~= nil then
					vanityitem.components.fueled.no_sewing = vanityitem.components.fueled.__no_sewing
				end
			end

			if vanityitem.components.perishable ~= nil then
				vanityitem.components.perishable:StartPerishing()
			end
		end
	end
end

-- Blocks containers when equipped as vanity.
global("ApplyContainerEffects")
ApplyContainerEffects = function(vanityitem, realitem, owner)	
	-- You wanted to carry two krampus sacks full of items? 💀💀
	-- Nah bro, you can't have containers with stuff inside. :steammocking:
	if vanityitem ~= nil and vanityitem.components.container ~= nil then
		vanityitem.components.container:DropEverything(owner:GetPosition())
		vanityitem.components.container:Close(owner)
			
		vanityitem.components.container.__restrictedtag = vanityitem.components.container.restrictedtag
		vanityitem.components.container.restrictedtag = "steammocking" -- https://tenor.com/view/steammocking-gif-24857170
	end
			
	if realitem ~= nil and realitem.components.container ~= nil then
		realitem.components.container:Open(owner)
	end
end

-- Restore original container effects.
global("RemoveContainerEffects")
RemoveContainerEffects = function(vanityitem, owner)
	if vanityitem ~= nil and vanityitem.components.container ~= nil then
		vanityitem.components.container.restrictedtag = vanityitem.components.container.__restrictedtag
	end
end

-- Dirty fix because Lantern and Shields uses the same symbol.
global("ApplyOverlayEffects")
ApplyOverlayEffects = function(vanityitem, realitem, owner)
	if realitem ~= nil and realitem:HasTag("vanity_lantern") and vanityitem ~= nil and not vanityitem:HasTag("vanity_shield") then
		owner.AnimState:Hide("LANTERN_OVERLAY")
	end

	if realitem ~= nil and realitem:HasTag("vanity_shield") and vanityitem ~= nil and not vanityitem:HasTag("vanity_shield") then
		owner.AnimState:ShowSymbol("swap_object")
		owner.AnimState:ClearOverrideSymbol("lantern_overlay")
	end
	
	if realitem ~= nil and realitem:HasTag("vanity_fullhead") and vanityitem ~= nil and not vanityitem:HasTag("vanity_fullhead") then
		owner.AnimState:ShowSymbol("swap_hat")
		owner.AnimState:ClearOverrideSymbol("headbase_hat")
		
		owner.AnimState:ShowSymbol("face")
		owner.AnimState:ShowSymbol("swap_face")
		owner.AnimState:ShowSymbol("beard")
		owner.AnimState:ShowSymbol("cheeks")
		
		owner.AnimState:UseHeadHatExchange(false)
	end
	
	if realitem ~= nil and realitem:HasTag("playerfloater") and vanityitem ~= nil then
		owner.AnimState:Hide("ARM_carry")
		owner.AnimState:Show("ARM_normal")
	end
end

global("RemoveOverlayEffects")
RemoveOverlayEffects = function(vanityitem, realitem, owner)
	if realitem ~= nil and realitem:HasTag("vanity_shield") then
		owner.AnimState:ClearOverrideSymbol("swap_object")
		owner.AnimState:ShowSymbol("lantern_overlay")
	end
	
	if realitem ~= nil and realitem:HasTag("vanity_fullhead") then
		owner.AnimState:ClearOverrideSymbol("swap_hat")
		owner.AnimState:ShowSymbol("headbase_hat")
	end
end

global("ApplyRealItemsFX")
ApplyRealItemsFX = function(realitem, owner)
	local skin_build = realitem:GetSkinBuild()

	if realitem.prefab == "spear_wathgrithr_lightning_charged" then
		if realitem.fx == nil then
			local FX_OFFSETS = 
			{
				DEFAULT = {0, 0, 0},
				["spear_wathgrithr_lightning_lunar"]    = {0,  20, 0},
				["spear_wathgrithr_lightning_valkyrie"] = {0,   0, 0},
				["spear_wathgrithr_lightning_wrestle"]  = {0, -20, 0},
				["spear_wathgrithr_lightning_northern"] = {0, -10, 0},
			}
	
			local offset = FX_OFFSETS[skin_build] or FX_OFFSETS.DEFAULT
	
			realitem.fx = SpawnPrefab("spear_wathgrithr_lightning_fx")
			realitem.fx.entity:SetParent(owner.entity)
			realitem.fx.Follower:FollowSymbol(owner.GUID, "swap_object", offset[1], offset[2], offset[3], true)
		end
	end
	
	if realitem.prefab == "sword_lunarplant" then
		if realitem.blade1 ~= nil then
			realitem.blade1.entity:Show()
		end
	
		if realitem.blade2 ~= nil then
			realitem.blade2.entity:Show()
		end
	end
	
	if realitem.prefab == "staff_lunarplant" then
		if realitem.fx ~= nil then
			realitem.fx.entity:Show()
		end
	end
end

-- Some items have persistent FX...
global("RemoveRealItemsFX")
RemoveRealItemsFX = function(realitem, owner)
	-- Special case for items with multiple fx.
	if realitem.fx ~= nil and realitem:HasTag("vanity_multiple_fx") then
		if realitem.fx then
			for i, v in ipairs(realitem.fx) do
				v:Remove()
			end
			
			realitem.fx = nil
		end
	elseif realitem.fx ~= nil and realitem:HasTag("vanity_toggable_fx") then
		realitem.fx:ToggleEquipped(false)
	elseif realitem.fx ~= nil and realitem:HasTag("vanity_persists_fx") then
		realitem.fx.entity:Hide()
	elseif realitem.fx ~= nil then
		realitem.fx:Remove()
		realitem.fx = nil
		
		if owner.SoundEmitter ~= nil then
			owner.SoundEmitter:KillSound("soundloop")
		end
	end

	if realitem._fx ~= nil then
		realitem._fx:Remove()
		realitem._fx = nil
	end

	if realitem.swapfx ~= nil then
		realitem.swapfx:Remove()
		realitem.swapfx = nil
	end

	if realitem.swapfx2 ~= nil then
		realitem.swapfx2:Remove()
		realitem.swapfx2 = nil
	end
	
	if realitem.blade1 ~= nil then
		realitem.blade1.entity:Hide()
	end
	
	if realitem.blade2 ~= nil then
		realitem.blade2.entity:Hide()
	end
	
	if realitem._wheel ~= nil then
        realitem._wheel:Remove()
		realitem._wheel = nil
    end
	
	--[[
	if realitem._front ~= nil then
		realitem._front:Remove()
		realitem._front = nil
	end
				
	if realitem._back ~= nil then
		realitem._back:Remove()
		realitem._back = nil
	end
	]]--
	
	if realitem._body ~= nil then
		realitem._body:Remove()
		realitem._body = nil
	end
	
	if realitem._charged_vfx ~= nil then
		realitem._charged_vfx:Remove()
		realitem._charged_vfx = nil
	end
	
	if realitem.wortox_nabbag_body ~= nil then
		realitem.wortox_nabbag_body:Remove()
		realitem.wortox_nabbag_body = nil
	end
end

-- Removes a specific Event Callback. because RemoveEventCallback requires fn, and
-- some fn are either hidden or local, some of them I couldn't even get with UpvalueHacker.
-- Source: https://forums.kleientertainment.com/forums/topic/46524-removing-a-specific-event-from-the-eventcallback-list/
global("RemoveEventListener")
RemoveEventListener = function(inst, event, prefab)
	if inst.event_listening then
		for e, sources  in pairs(inst.event_listening) do
			if e == event then
				for s, _ in pairs(sources) do
					if prefab == nil and s.event_listeners and s.event_listeners[e] then
						s.event_listeners[e][inst] = nil
					elseif s.prefab == prefab and s.event_listeners and s.event_listeners[e] then
						s.event_listeners[e][inst] = nil	                
					end
				end
			end
		end
	end
	
	if inst.event_listeners then
		for e, listeners in pairs(inst.event_listeners) do
			if e == event then
				for listener, _ in pairs(listeners) do
					if listener.event_listening and listener.event_listening[e] then
						listener.event_listening[e][inst] = nil
					end
				end
			end
		end
	end
end

--[[
global("RemoveVanityEventCallback")
RemoveVanityEventCallback = function(inst, eventname, prefabname)
	-- Will store the callback event set up by the prefab.
	local eventname
	if inst.event_listening.eventname and inst.event_listening.eventname[inst] then
		for _, fn in ipairs(inst.event_listening.eventname[inst]) do
			local info = _G.debug.getinfo(fn, "S")
				
			if info and info.source then
				if info.source:match(prefabname) then -- "prefabs[/\\]hats.lua$"
					eventname = fn
					break
				end
			end
		end
	end
	
	if eventname then
		inst:RemoveEventCallback(eventname, eventname)
	end
]]--