-- Common Dependencies.
local _G            = GLOBAL
local require       = _G.require
local ACTIONS       = _G.ACTIONS
local STRINGS       = _G.STRINGS
local EQUIPSLOTS    = _G.EQUIPSLOTS
local UpvalueHacker = require("vs_upvaluehacker")

local EQUIPSLOTS_VANITYSLOTS_INDEX =
{
    [EQUIPSLOTS.HANDS] = 1,
    [EQUIPSLOTS.BODY]  = 2,
    [EQUIPSLOTS.HEAD]  = 3,
}

local INVERTED_EQUIPSLOTS_VANITYSLOTS_INDEX = table.invert(EQUIPSLOTS_VANITYSLOTS_INDEX)

-- Action for equipping items that can't go in inventory as vanity. i.e Backpacks.
AddAction("EQUIPVANITY", STRINGS.ACTIONS.EQUIPVANITY, function(act)
	local owner = act.doer
	local vanityitem = act.target
	local vanityslot = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
	
	if owner ~= nil then
		if vanityslot and vanityitem then
			vanityslot.components.container:GiveItem(vanityitem, vanityslot, vanityitem:GetPosition())
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

-- Hack to prevent players from using tophat container when equipped as vanity.
local COMPONENT_ACTIONS = UpvalueHacker.GetUpvalue(_G.EntityScript.CollectActions, "COMPONENT_ACTIONS")
local INVENTORY = COMPONENT_ACTIONS.INVENTORY

local _INVENTORY_magiciantool = INVENTORY.magiciantool
function INVENTORY.magiciantool(inst, doer, actions, right)
	if doer:HasTag("magician") and not inst:HasTag("vanity_cannotuse") then
		if not doer.components.playercontroller.isclientcontrollerattached and
		(right or doer.components.playercontroller:IsControlPressed(CONTROL_FORCE_INSPECT)) then
			table.insert(actions, ACTIONS.USEMAGICTOOL)
		else
			local equippable = inst.replica.equippable		
			if equippable ~= nil and equippable:IsEquipped() and not inst:HasTag("vanity_cannotuse") then
				table.insert(actions, ACTIONS.USEMAGICTOOL)
			end
		end
	end
end