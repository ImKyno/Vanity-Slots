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
			-- Not really necessary as hats already have consistent tag "hat".
			-- Still, will make this tag in case someone needs it.
			inst:AddTag("vanity_head")
		end
		
		-- Tag for general purposes.
		-- NOTE: DO NOT use this tag for the vanity slots.
		inst:AddTag("vanity_item")
	end
end

AddPrefabPostInitAny(MakeVanityItem)

-- Below is numerous required postinits for some specific items that couldn't be done automatically.
local VANITY_COMMON_ITEMS =
{

}

local function OnEquipToModelCommon(inst, owner)
	
end

local function LanternPostInit(inst)
	local _OnEquipToModel
	local function OnEquipToModel(inst, owner, from_ground)
		if inst.components.equippable:IsEquipped() then
			inst.components.inventoryitem:GetGrandOwner().AnimState:Hide("LANTERN_OVERLAY")
		end
		
		return _OnEquipToModel(inst, owner, from_ground)
	end
	
	if not _G.TheWorld.ismastersim then	
		return inst
	end
	
	if inst.components.equippable ~= nil then
		_OnEquipToModel = inst.components.equippable.onequiptomodelfn
		inst.components.equippable.onequiptomodelfn = OnEquipToModel
	end
end

AddPrefabPostInit("lantern", LanternPostInit)

-- Items that can't go in containers.
local VANITY_RESTRICTED_ITEMS =
{
	"backpack",
	"candybag",
	"icepack",
	"krampus_sack",
	"piggyback",
	"propsign",
	"seedpouch",
	"slurper",
	"spicepack",
}

local function RestrictedItemsPostinit(inst)
	inst:AddTag("vanity_item_restricted")
end

for k, item in pairs(VANITY_RESTRICTED_ITEMS) do
	AddPrefabPostInit(item, RestrictedItemsPostinit)
end