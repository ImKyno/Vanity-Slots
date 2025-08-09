-- Common Dependencies.
local containers = require("containers")
local params     = {}

local containers_widgetsetup_base = containers.widgetsetup
function containers.widgetsetup(container, prefab, data, ...)
	local t = params[prefab or container.inst.prefab]
	
	if t ~= nil then
		for k, v in pairs(t) do
			container[k] = v
		end

		container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
	else
		containers_widgetsetup_base(container, prefab, data, ...)
	end
end

-- I don't think its possible to make a vanity slot that 
-- Does not conflict with equippable and inventory components and other slot mods (?) 
-- So... we are making a container attached to the player instead 💀💀
params.vanity_slots =
{
	widget =
	{
		slotpos = 
		{
			Vector3(-(64 + 12), 7, 0),
			Vector3(0,          7, 0),
			Vector3(64 + 12,    7, 0),
		},
		
		slotbg =
		{
			{ image = "equip_slot.tex",      atlas = "images/hud.xml" },
			{ image = "equip_slot_body.tex", atlas = "images/hud.xml" },
			{ image = "equip_slot_head.tex", atlas = "images/hud.xml" },
		},
		
		animbank = "ui_chest_3x1",
		animbuild = "ui_chest_3x1",
		pos = Vector3(590, -448, 0),
	},
	
	type = "vanity",
	acceptsstacks = false,
	excludefromcrafting = true,
	lowpriorityselection = true,
	usespecificslotsforitems = true,
}

function params.vanity_slots.itemtestfn(container, item, slot)
	-- Ugly but it does the job.
	if slot == 1 then
		return item:HasTag("vanity_hand")
	elseif slot == 2 then
		return item:HasTag("vanity_body")
	elseif slot == 3 then
		return item:HasTag("vanity_head") or item:HasTag("hat") -- Why only hats have consistent tag?
	elseif slot == nil then
		return item:HasAnyTag("vanity_hand", "vanity_body", "vanity_head", "hat")
	end
	
	return false
end

-- References:
-- pos = Vector3(310, -29, 0), -- hand_inv 
-- pos = Vector3(-240, -448, 0), -- side_inv_behind

-- hand_inv
-- Vector3(-(64 + 12), 1, 0),
-- Vector3(0,          1, 0),
-- Vector3(64 + 12,    1, 0),