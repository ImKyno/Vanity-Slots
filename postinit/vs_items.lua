-- Common Dependencies.
local _G           = GLOBAL
local require      = _G.require
local EQUIPSLOTS   = _G.EQUIPSLOTS

require("vs_tuning")

-- This can techincally make hidden items like Bishop shot, 
-- Rook charge, Ewecus spit, etc. an equippable vanity item. Amazing!
local function MakeVanityItem(inst)
	local equippable = inst.replica.equippable
	
	if equippable ~= nil then
		local eslot = equippable:EquipSlot()
		
		if eslot == EQUIPSLOTS.HANDS then
			inst:AddTag("vanity_hand")
		elseif eslot == EQUIPSLOTS.BODY then
			inst:AddTag("vanity_body")
		elseif eslot == EQUIPSLOTS.HEAD then
			inst:AddTag("vanity_head")
		end
		
		-- Tag for general purposes.
		-- NOTE: DO NOT use this tag for the vanity slots.
		inst:AddTag("vanity_item")
	end
end

AddPrefabPostInitAny(MakeVanityItem)

-- Items that have client-side FX.
local function ItemsFXPostInit(inst)
	inst:AddTag("vanity_has_fx")
end

for k, item in pairs(TUNING.VANITY_HASFX_ITEMS) do
	AddPrefabPostInit(item, ItemsFXPostInit)
end

local function ItemsPersistsFXPostInit(inst)
	inst:AddTag("vanity_persists_fx")
end

for k, item in pairs(TUNING.VANITY_PERSISTSFX_ITEMS) do
	AddPrefabPostInit(item, ItemsPersistsFXPostInit)
end

local function ItemsMultipleFXPostInit(inst)
	inst:AddTag("vanity_multiple_fx")
end

for k, item in pairs(TUNING.VANITY_MULTIPLEFX_ITEMS) do
	AddPrefabPostInit(item, ItemsMultipleFXPostInit)
end

local function ItemsToggableFXPostInit(inst)
	inst:AddTag("vanity_toggable_fx")
end

for k, item in pairs(TUNING.VANITY_TOGGABLEFX_ITEMS) do
	AddPrefabPostInit(item, ItemsToggableFXPostInit)
end

-- Items that can't go in containers.
local function RestrictedItemsPostInit(inst)
	inst:AddTag("vanity_item_restricted")
end

for k, item in pairs(TUNING.VANITY_RESTRICTED_ITEMS) do
	AddPrefabPostInit(item, RestrictedItemsPostInit)
end

-- Items that can't be equipped regardless.
local function ForbidItemsPostInit(inst)
	inst:AddTag("vanity_item_forbid")
end

for k, item in pairs(TUNING.VANITY_FORBID_ITEMS) do
	AddPrefabPostInit(item, ForbidItemsPostInit)
end