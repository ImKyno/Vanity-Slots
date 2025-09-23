-- Common Dependencies.
local _G            = GLOBAL
local require       = _G.require
local ACTIONS       = _G.ACTIONS
local STRINGS       = _G.STRINGS
local EQUIPSLOTS    = _G.EQUIPSLOTS
local UpvalueHacker = require("vs_upvaluehacker")

local EQUIPSLOTS_VANITYSLOTS_INDEX = TUNING.EQUIPSLOTS_VANITYSLOTS_INDEX
local INVERTED_EQUIPSLOTS_VANITYSLOTS_INDEX = table.invert(EQUIPSLOTS_VANITYSLOTS_INDEX)

-- Action for equipping items that can't go in inventory as vanity. i.e Backpacks.
AddAction("EQUIPVANITY", STRINGS.ACTIONS.EQUIPVANITY, function(act)
    local owner = act.doer
    local vanityitem = act.target
    local vanityslots = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
    local equipslot = EQUIPSLOTS_VANITYSLOTS_INDEX[vanityslots.components.equippable.equipslot]

    local equippedslot = EQUIPSLOTS_VANITYSLOTS_INDEX[vanityitem.components.equippable.equipslot]
    local equippeditem = vanityslots ~= nil and vanityslots.components.container:GetItemInSlot(equippedslot)

    if owner ~= nil and vanityslots ~= nil and vanityitem ~= nil then
		if vanityitem.onpreequipvanity ~= nil then
			vanityitem.onpreequipvanity(vanityitem, owner)
		end

        if equippeditem ~= nil then
            if owner ~= nil and owner.components.inventory ~= nil then
                local equippeditem2 = vanityslots.components.container:RemoveItemBySlot(equippedslot)

                if equippeditem2 ~= nil then
                    equippeditem2.prevcontainer = nil
                    equippeditem2.prevslot = nil
                    owner.components.inventory:GiveItem(equippeditem, nil, owner:GetPosition())
                end
            else
                vanityslots.components.container:DropItem(equippeditem)
            end
        end

        vanityslots.components.container:GiveItem(vanityitem, equipslot, vanityitem:GetPosition())
		
        if vanityitem.onequipvanity ~= nil then
            vanityitem.onequipvanity(vanityitem, owner)
        end

		-- Can't be set here. Will set on HideEquippedItem function instead.
		-- keepcangoincontainer.cangoincontainer = keepcangoincontainer.__cangoincontainer

        return true
    end
end)

ACTIONS.EQUIPVANITY.priority = 2
ACTIONS.EQUIPVANITY.mount_valid = true

AddComponentAction("SCENE", "inventoryitem", function(inst, doer, actions, right)
	if right then
		if inst:HasTag("vanity_item_restricted") and not inst:HasTag("heavy")
		and doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.VANITY) then
			table.insert(actions, ACTIONS.EQUIPVANITY)
		end
	end
end)

-- Hack to prevent players from doing actions when item is equipped as vanity.
local COMPONENT_ACTIONS = UpvalueHacker.GetUpvalue(_G.EntityScript.CollectActions, "COMPONENT_ACTIONS")
local EQUIPPED = COMPONENT_ACTIONS.EQUIPPED
local INVENTORY = COMPONENT_ACTIONS.INVENTORY
local POINT = COMPONENT_ACTIONS.POINT
local USEITEM = COMPONENT_ACTIONS.USEITEM

local _EQUIPPED_complexprojectile = EQUIPPED.complexprojectile
function EQUIPPED.complexprojectile(inst, ...)
	if inst:HasTag("vanity_equipped") then
		return false
	else
		return _EQUIPPED_complexprojectile(inst, ...)
	end
end

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

local _INVENTORY_spellcaster = INVENTORY.spellcaster
function INVENTORY.spellcaster(inst, ...)
	if inst:HasTag("vanity_equipped") then
		return
	else
		return _INVENTORY_spellcaster(inst, ...)
	end
end

local _INVENTORY_channelcastable = INVENTORY.channelcastable
function INVENTORY.channelcastable(inst, ...)
	if inst:HasTag("vanity_equipped") then
		return
	else
		return _INVENTORY_channelcastable(inst, ...)
	end
end

local _POINT_complexprojectile = POINT.complexprojectile
function POINT.complexprojectile(inst, ...)
	if inst:HasTag("vanity_equipped") then
		return false
	else
		return _POINT_complexprojectile(inst, ...)
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

local _USEITEM_cookable = USEITEM.cookable
function USEITEM.cookable(inst, doer, target, ...)
	if target:HasTag("vanity_equipped") then
		return
	else
		return _USEITEM_cookable(inst, doer, target, ...)
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