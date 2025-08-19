-- Common Dependencies.
local _G         = GLOBAL
local require    = _G.require
local ACTIONS    = _G.ACTIONS
local STRINGS    = _G.STRINGS
local EQUIPSLOTS = _G.EQUIPSLOTS

local EQUIPSLOTS_TO_SLOT_INDEX_MAP =
{
    [EQUIPSLOTS.HANDS] = 1,
    [EQUIPSLOTS.BODY]  = 2,
    [EQUIPSLOTS.HEAD]  = 3,
}

-- Action for equipping items that can't go in inventory as vanity. i.e Backpacks.
AddAction("EQUIPVANITY", STRINGS.ACTIONS.EQUIPVANITY, function(act)
	local owner = act.doer or nil
	local vanityitem = act.target or nil
	local vanityslots = owner.components.inventory:GetItemInSlot(EQUIPSLOTS_TO_SLOT_INDEX_MAP[vanityitem.components.equippable.equipslot]) or nil
	
	if owner ~= nil then
		if vanityitem ~= nil then
			vanityitem.components.equippable:Equip(vanityslots)
			return true
		end
	end
end)

ACTIONS.EQUIPVANITY.priority = 2
ACTIONS.EQUIPVANITY.mount_valid = true

AddComponentAction("SCENE", "inventoryitem", function(inst, doer, actions, right)
	-- Don't show action if the hovered item is a heavy object (statues).
	if right then
		if inst:HasTag("vanity_item_restricted") and not inst:HasTag("heavy") then
			table.insert(actions, ACTIONS.EQUIPVANITY)
		end
	end
end)