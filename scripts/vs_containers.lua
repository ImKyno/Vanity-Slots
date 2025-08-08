-- Common Dependencies.
local containers = require("containers")
local params     = containers.params

-- I don't think its possible to make a vanity slot that 
-- Does not conflict with equippable and inventory components and other slot mods (?) 
-- So... we are making a container attached to the player instead!
params.vanity_slots =
{
	widget =
	{
		slotpos = 
		{
			Vector3(-(64 + 12), 1, 0),
			Vector3(0,          1, 0),
			Vector3(64 + 12,    1, 0),
		},
		
		slotbg =
		{
			{ image = "vanity_slot_hand.tex", atlas = "images/vanity_slots.xml" },
			{ image = "vanity_slot_body.tex", atlas = "images/vanity_slots.xml" },
			{ image = "vanity_slot_head.tex", atlas = "images/vanity_slots.xml" },
		},
		
		animbank = "ui_chest_3x1",
		animbuild = "ui_chest_3x1",
		pos = Vector3(310, -29, 0), -- Perhaps let them decide the position.
	},
	
	type = "hand_inv",
	acceptsstacks = false,
	excludefromcrafting = true,
	lowpriorityselection = true,
}

function params.vanity_slots.itemtestfn(container, item, slot)
	-- Ugly but it does the job.
	if slot == 1 then
		return item:HasTag("vanity_hand")
	elseif slot == 2 then
		return item:HasTag("vanity_body")
	elseif slot == 3 then
		return item:HasTag("vanity_head")
	elseif slot == nil then
		return item:HasAnyTag("vanity_hand", "vanity_body", "vanity_head")
	end
	
	return false
end