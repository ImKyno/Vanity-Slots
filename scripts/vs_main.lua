-- Initialize all the needed stuff.
require("vs_constants")
require("vs_containers")
require("vs_tuning")
require("vs_upvaluehacker")
require("strings/vs_strings")

-- Function to fix issues when vanity item is equipped when hiding.
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

-- Function for applying common effects to vanity items.
global("ApplyVanityEffects")
ApplyVanityEffects = function(vanityitem, owner)
	if vanityitem == nil then
		return print("VANITY SLOTS: COULDN'T APPLY VANITY EFFECTS")
	end
	
	if not vanityitem:HasTag("vanity_equipped") then
		vanityitem:AddTag("vanity_equipped")
	end
	
	if vanityitem.onequipvanity ~= nil then
		vanityitem.onequipvanity(vanityitem, owner)
	else
		print("VANITY SLOTS: ITEM WITHOUT \"onequipvanity\" EQUIPPED.")
		print("VANITY SLOTS: LIKELY A MODDED ITEM.")
		print("VANITY SLOTS: APPLYING DEFAULT VANITY EFFECTS.")
				
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
	
	--[[
	local container = vanityitem.components.container
	if container ~= nil then
		container:DropEverything(owner:GetPosition())
		-- container:Close(owner)
			
		container.__restrictedtag = container.restrictedtag
		container.restrictedtag = "steammocking"
	end
	]]--
end

-- Function for removing common effects from vanity items.
global("RemoveVanityEffects")
RemoveVanityEffects = function(vanityitem, owner)
	if vanityitem == nil then
		return print("VANITY SLOTS: COULDN'T REMOVE VANITY EFFECTS")
	end

	if vanityitem:HasTag("vanity_equipped") then
		vanityitem:RemoveTag("vanity_equipped")
	end

	if vanityitem.onunequipvanity ~= nil then
		vanityitem.onunequipvanity(vanityitem, owner)
	else
		print("VANITY SLOTS: ITEM WITHOUT \"onunequipvanity\" EQUIPPED.")
		print("VANITY SLOTS: LIKELY A MODDED ITEM.")
		print("VANITY SLOTS: REMOVING DEFAULT VANITY EFFECTS.")

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

	--[[
	local container = vanityitem.components.container
	if container ~= nil then
		container.restrictedtag = container.__restrictedtag
	end
	]]--
end