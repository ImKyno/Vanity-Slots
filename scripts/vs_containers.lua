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

-- I don't think its possible to make a equip slot that does not
-- conflict with equippable and inventory components and other slot mods (?) 
-- so... we are making a container attached to the player instead 💀💀

-- UPDATE: Setting position for both widget and container is a pain in the ass
-- I'll just hardcode the position below the player, this way I don't need to 
-- lose my sanity while making it compatible with pesky mods that add 100 inv slots.

-- TO DO (MAYBE): Make position compatible with mods that change the inventory size.
params.vanity_slots =
{
	widget =
	{
		slotpos = 
		{
			Vector3(-(64 + 12), 0, 0),
			Vector3(0,          0, 0),
			Vector3(64 + 12,    0, 0),
		},
		
		slotbg =
		{	-- Using game assets, this way it should already be compatible with HUD skin mods.
			{ image = "equip_slot.tex",      atlas = "images/hud.xml" },
			{ image = "equip_slot_body.tex", atlas = "images/hud.xml" },
			{ image = "equip_slot_head.tex", atlas = "images/hud.xml" },
		},
		
		animbank = "ui_chest_3x1",
		animbuild = "ui_chest_3x1",
		pos = Vector3(0, 320, 0),
	},
	
	acceptsstacks = false,
	excludefromcrafting = true,
	lowpriorityselection = true,
	usespecificslotsforitems = true,
	type = "vanity", -- DO NOT use known same types because opening another will close us.
}

function params.vanity_slots.itemtestfn(container, item, slot)
	local CANT_TAGS = item:HasAnyTag("vanity_item_forbid", "heavy", "broken")
	local MUST_TAGS = item:HasAnyTag("vanity_hand", "vanity_body", "vanity_head")

	return (slot == 1 and (item:HasTag("vanity_hand") and not CANT_TAGS))
        or (slot == 2 and (item:HasTag("vanity_body") and not CANT_TAGS))
        or (slot == 3 and (item:HasTag("vanity_head") and not CANT_TAGS))
		-- This is causing a bug where you can't move items from other containers
		-- and also it takes priority over other containers when moving.
		or (slot == nil and (MUST_TAGS) and not (CANT_TAGS))
end

-- References:
-- pos = Vector3(0, -300, 0), -- vanity
-- pos = Vector3(310, -29, 0), -- hand_inv 
-- pos = Vector3(-240, -448, 0), -- side_inv_behind

-- hand_inv
-- Vector3(-(64 + 12), 1, 0),
-- Vector3(0,          1, 0),
-- Vector3(64 + 12,    1, 0),

-- Horizontal slots
--[[
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
	
-- Vertical slots
	widget =
	{
		slotpos =
		{
			Vector3(-1, 32 + 4,             0),
            Vector3(-1, -(32 + 4),          0),
			Vector3(-1, -(64 + 32 + 8 + 4), 0),
		},
		
		slotbg =
		{
			{ image = "equip_slot.tex",      atlas = "images/hud.xml" },
			{ image = "equip_slot_head.tex", atlas = "images/hud.xml" },
			{ image = "equip_slot_body.tex", atlas = "images/hud.xml" },
		},
		
		animbank = "ui_vanity_1x3",
		animbuild = "ui_vanity_1x3",
		pos = Vector3(530, -285, 0),
	},
	
function params.vanity_slots.itemtestfn(container, item, slot)
	local forbidtags = item:HasTag("vanity_item_forbid") 
	or item:HasTag("heavy") or item:HasTag("broken")

	if slot == 1 then
		return item:HasTag("vanity_hand") and not forbidtags
	elseif slot == 2 then
		return item:HasTag("vanity_body") and not forbidtags
	elseif slot == 3 then
		return item:HasTag("vanity_head") and not forbidtags
	elseif slot == nil then
		return item:HasAnyTag("vanity_hand", "vanity_body", "vanity_head") and not forbidtags
	end
	return false
end
]]--