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

-- Below is numerous required postinits for some specific items that couldn't be done automatically.

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

-- TO DO: Fix these items:
-- minerhat (invisible when vanity)
-- tophat magician (can open container with alt key when vanity)

-- alterguardianhat (gives light when vanity)
-- wagpunkhat (gives buff and crashes)
-- inspectacleshat (dont hide when vanity equipped)
-- voidclothhat (dont hide when vanity equipped)
-- lunarplanthat (dont hide when vanity equipped)

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

local function MinerHatPostInit(inst)
	local _OnEquip
	local function OnEquip(isnt)
		-- Minherhat light checks for owner, but our owner is the vanityslot and not the player.
		local owner = inst.components.inventoryitem ~= nil 
		and inst.components.inventoryitem:GetGrandOwner() or nil
		print("VANITY SLOTS MINERHAT OWNER:", owner)

		return _OnEquip(inst)
	end
	
	if not _G.TheWorld.ismastersim then	
		return inst
	end
	
	if inst.components.equippable ~= nil then
		_OnEquip = inst.components.equippable.onequipfn
		inst.components.equippable.onequipfn = OnEquip
	end
end

AddPrefabPostInit("minerhat", MinerHatPostInit)

local function FeatherHatPostInit(inst)
	local function OnEquipToModel(isnt, owner, from_ground)
		local attractor = owner.components.birdattractor
		local birdspawner = _G.TheWorld.components.birdspawner
		
		if attractor then
			attractor.spawnmodifier:RemoveModifier(inst)

			if birdspawner ~= nil then
				birdspawner:ToggleUpdate(true)
			end
		end
		
		if inst.components.fueled ~= nil then
			inst.components.fueled:StopConsuming()
		end
	end
	
	if not _G.TheWorld.ismastersim then	
		return inst
	end
	
	if inst.components.equippable ~= nil then
		inst.components.equippable:SetOnEquipToModel(OnEquipToModel)
	end
end

AddPrefabPostInit("featherhat", FeatherHatPostInit)

local function RuinsHatPostInit(inst)
	local function OnEquipToModel(inst, owner, from_ground)
		if inst._fx ~= nil then
			inst._fx:kill_fx()
			inst._fx = nil
		end
		
		if inst._task ~= nil then
            inst._task:Cancel()
			inst._task = nil
        end
		
		inst.ondetach()
	end
	
	if not _G.TheWorld.ismastersim then	
		return inst
	end
	
	if inst.components.equippable ~= nil then
		inst.components.equippable:SetOnEquipToModel(OnEquipToModel)
	end
end

AddPrefabPostInit("ruinshat", RuinsHatPostInit)

local function HiveHatPostInit(inst)
	local function OnEquipToModel(inst, owner, from_ground)
		if owner ~= nil and owner.components.sanity ~= nil then
			owner.components.sanity.neg_aura_absorb = 0
		end
	end
	
	if not _G.TheWorld.ismastersim then	
		return inst
	end
	
	if inst.components.equippable ~= nil then
		inst.components.equippable:SetOnEquipToModel(OnEquipToModel)
	end
end

AddPrefabPostInit("hivehat", HiveHatPostInit)

local function SkeletonHatPostInit(inst)
	local function OnEquipToModel(inst, owner, from_ground)
		if owner.components.sanity ~= nil then
			owner.components.sanity:SetInducedInsanity(inst, false)
			owner:RemoveTag("shadowdominance")
		end
	end
	
	if not _G.TheWorld.ismastersim then	
		return inst
	end
	
	if inst.components.equippable ~= nil then
		-- inst.components.equippable.onequiptomodelfn = OnEquipToModel
		inst.components.equippable:SetOnEquipToModel(OnEquipToModel)
	end
end

AddPrefabPostInit("skeletonhat", SkeletonHatPostInit)

local function AntlionHatPostInit(inst)
	local function OnEquipToModel(inst, owner, from_ground)
		if owner ~= nil then
			if inst.components.autoterraformer ~= nil then
				inst.components.autoterraformer:StopTerraforming()
			end
			
			owner:RemoveTag("turfhat")
		end
	end
	
	if not _G.TheWorld.ismastersim then	
		return inst
	end
	
	if inst.components.equippable ~= nil then
		inst.components.equippable:SetOnEquipToModel(OnEquipToModel)
	end
end

AddPrefabPostInit("antlionhat", AntlionHatPostInit)

local function MonkeySmallHatPostInit(inst)
	local function OnEquipToModel(inst, owner, from_ground)
		if owner ~= nil then
			owner:RemoveTag("master_crewman")
		end
	end
	
	if not _G.TheWorld.ismastersim then	
		return inst
	end
	
	if inst.components.equippable ~= nil then
		inst.components.equippable:SetOnEquipToModel(OnEquipToModel)
	end
end

AddPrefabPostInit("monkey_smallhat", MonkeySmallHatPostInit)

local function MonocleHatPostInit(inst)
	local function OnEquipToModel(inst, owner, from_ground)
		if owner ~= nil then
			owner:RemoveCameraExtraDistance(inst)
			owner:RemoveTag("scrapmonolevision")
		end
	end
	
	if not _G.TheWorld.ismastersim then	
		return inst
	end
	
	if inst.components.equippable ~= nil then
		inst.components.equippable:SetOnEquipToModel(OnEquipToModel)
	end
end

AddPrefabPostInit("scrap_monoclehat", MonocleHatPostInit)