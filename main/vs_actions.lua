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
	local equipslot = EQUIPSLOTS_VANITYSLOTS_INDEX[vanityslot.components.equippable.equipslot]

	if owner ~= nil and vanityslot ~= nil and vanityitem ~= nil then
		vanityitem.components.inventoryitem.cangoincontainer = true
		
		vanityslot.components.container:GiveItem(vanityitem, equipslot, vanityitem:GetPosition())
		
		if vanityitem.onequipvanity ~= nil then
			vanityitem.onequipvanity(vanityitem, owner)
		end
		
		vanityitem.components.inventoryitem.cangoincontainer = false
		
		return true
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

-- Hack to prevent players from doing actions when item is equipped as vanity.
local COMPONENT_ACTIONS = UpvalueHacker.GetUpvalue(_G.EntityScript.CollectActions, "COMPONENT_ACTIONS")
local INVENTORY = COMPONENT_ACTIONS.INVENTORY
local USEITEM = COMPONENT_ACTIONS.USEITEM

local _INVENTORY_magiciantool = INVENTORY.magiciantool
function INVENTORY.magiciantool(inst, ...)
	if inst:HasTag("vanity_equipped") then 
		return
	else 
		return _INVENTORY_magiciantool(inst, ...) 
	end
end

local _INVENTORY_equippable = INVENTORY.equippable
function INVENTORY.equippable(inst, ...)
	if inst:HasTag("vanity_equipped") then
		return
	else
		return _INVENTORY_equippable(inst, ...)
	end
end

local _INVENTORY_container = INVENTORY.container
function INVENTORY.container(inst, ...)
	if inst:HasTag("vanity_equipped") then
		return
	else
		return _INVENTORY_container(inst, ...)
	end
end

local _INVENTORY_useableitem = INVENTORY.useableitem
function INVENTORY.useableitem(inst, ...)
	if inst:HasTag("vanity_equipped") then
		return 
	else
		return _INVENTORY_useableitem(inst, ...)
	end
end

local _USEITEM_ghostlyelixir = USEITEM.ghostlyelixir
function USEITEM.ghostlyelixir(inst, doer, target, ...)
	if target:HasTag("vanity_equipped") then
		return
	else
		return _USEITEM_ghostlyelixir(inst, doer, target, ...)
	end
end

local _USEITEM_repairer = USEITEM.repairer
function USEITEM.repairer(inst, doer, target, ...)
	if target:HasTag("vanity_equipped") then
		return
	else
		return _USEITEM_repairer(inst, doer, target, ...)
	end
end

local _USEITEM_forgerepair = USEITEM.forgerepair
function USEITEM.forgerepair(inst, doer, target, ...)
	if target:HasTag("vanity_equipped") then
		return
	else
		return _USEITEM_forgerepair(inst, doer, target, ...)
	end
end

local _USEITEM_sewing = USEITEM.sewing
function USEITEM.sewing(inst, doer, target, ...)
	if target:HasTag("vanity_equipped") then
		return
	else
		return _USEITEM_sewing(inst, doer, target, ...)
	end
end

local _USEITEM_edible = USEITEM.edible
function USEITEM.edible(inst, doer, target, ...)
	if target:HasTag("vanity_equipped") then
		return
	else
		return _USEITEM_edible(inst, doer, target, ...)
	end
end

local _USEITEM_fuel = USEITEM.fuel
function USEITEM.fuel(inst, doer, target, ...)
	if target:HasTag("vanity_equipped") then
		return
	else
		return _USEITEM_fuel(inst, doer, target, ...)
	end
end

local _USEITEM_inventoryitem = USEITEM.inventoryitem
function USEITEM.inventoryitem(inst, doer, target, ...)
	if target:HasTag("vanity_equipped") then
		return
	else
		return _USEITEM_inventoryitem(inst, doer, target, ...)
	end
end