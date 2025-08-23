-- Initialize all the needed stuff.
require("vs_constants")
require("vs_containers")
require("vs_tuning")
require("vs_upvaluehacker")
require("strings/vs_strings")

-- Global function for applying common effects to vanity items.
global("ApplyVanityEffects")
ApplyVanityEffects = function(vanityitem)
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
			
	-- You wanted to carry two krampus sacks full of items? 💀💀
	-- Nah bro, you can't have containers with stuff inside. :steammocking:
	local container = vanityitem.components.container
	if container ~= nil then
		container:DropEverything(owner:GetPosition())
		container:Close(owner)
			
		container.__restrictedtag = container.restrictedtag
		container.restrictedtag = "steammocking" -- https://tenor.com/view/steammocking-gif-24857170
	end
end

-- Global function for removing common effects from vanity items.
global("RemoveVanityEffects")
RemoveVanityEffects = function(vanityitem)
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

	local container = vanityitem.components.container
	if container ~= nil then
		container.restrictedtag = container.__restrictedtag
	end
end