-- Common Dependencies.
local _G            = GLOBAL
local require       = _G.require
local EQUIPSLOTS    = _G.EQUIPSLOTS
local UpvalueHacker = require("vs_upvaluehacker")

require("vs_tuning")

-- TO DO: Fix these items:
-- bushhat (player invisible when equipping vanity animated hat)

-- alterguardianhat (gives light when vanity)
-- wagpunkhat (fx does not update when vanity is equipped)
-- voidclothhat (dont hide when vanity equipped)
-- lunarplanthat (dont hide when vanity equipped)

-- Why the fuck are we not using "onequiptomodel" instead?
-- onequiptomodel messes up with Mannequin and we don't want that. We are going to
-- create our own model function that acts solely for the vanity slots and won't mess
-- with other game clothing features (I hope).

local function CommonPostInit(inst)
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			if inst.components.fueled ~= nil then
				inst.components.fueled:StopConsuming()
				
				if inst.components.fueled.accepting ~= nil then
					inst.components.fueled.__accepting = inst.components.fueled.accepting
					inst.components.fueled.accepting = false
				end
				
				if inst.components.fueled.no_sewing ~= nil then
					inst.components.fueled.__no_sewing = inst.components.fueled.no_sewing
					inst.components.fueled.no_sewing = true
				end
			end
			
			if inst.components.perishable ~= nil then
				inst.components.perishable:StopPerishing()
			end
		end
	end
	
	inst.onunequipvanity = function(inst, owner)
		if owner ~= nil then
			if inst.components.fueled ~= nil then
				if inst.components.fueled.accepting ~= nil then
					inst.components.fueled.accepting = inst.components.fueled.__accepting
				end
				
				if inst.components.fueled.no_sewing ~= nil then
					inst.components.fueled.no_sewing = inst.components.fueled.__no_sewing
				end
				
				if inst.components.equippable:IsEquipped() then
					inst.components.fueled:StartConsuming()
				end
			end
			
			if inst.components.perishable ~= nil then
				inst.components.perishable:StartPerishing()
			end
		end
	end
end

for k, item in pairs(TUNING.VANITY_COMMON_HEAD_ITEMS) do
	AddPrefabPostInit(item, CommonPostInit)
end

local function MushroomHatPostInit(inst)
	inst.mushroom_onattacked_moonspore_tryspawn = function(hat)
		if hat.components.periodicspawner == nil then
			hat._moonspore_tryspawn_count = nil
			return
		end

		hat.components.periodicspawner:TrySpawn()
		hat._moonspore_tryspawn_count = hat._moonspore_tryspawn_count - 1
		
		if hat._moonspore_tryspawn_count <= 0 then
			hat._moonspore_tryspawn_count = nil
			return
		end

		hat:DoTaskInTime(TUNING.MUSHROOMHAT_MOONSPORE_RETALIATION_SPORE_DELAY, inst.mushroom_onattacked_moonspore_tryspawn)
	end
	
	inst.mushroom_onattacked_moonspore = function(inst, data)
		local hat = inst.components.inventory ~= nil and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) or nil
        
		if hat ~= nil then
			if hat._moonspore_tryspawn_count == nil then
				hat:DoTaskInTime(TUNING.MUSHROOMHAT_MOONSPORE_RETALIATION_SPORE_DELAY, inst.mushroom_onattacked_moonspore_tryspawn)
			end
			
			hat._moonspore_tryspawn_count = TUNING.MUSHROOMHAT_MOONSPORE_RETALIATION_SPORE_COUNT
		end
	end

	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			if inst.components.perishable ~= nil then
				inst.components.perishable:StopPerishing()
			end
			
			if owner.components.hunger ~= nil then
				owner.components.hunger.burnratemodifiers:RemoveModifier(inst)
			end
			
			if inst.components.periodicspawner ~= nil then
				inst.components.periodicspawner:Stop()
			end
			
			if inst._ismoonspore then
				owner:RemoveTag("moon_spore_protection")
				inst:RemoveEventCallback("attacked", inst.mushroom_onattacked_moonspore, owner)
			end
			
			owner:RemoveTag("spoiler")
		end
	end
	
	inst.onunequipvanity = function(inst, owner)
		if owner ~= nil then
			if inst.components.perishable ~= nil then
				inst.components.perishable:StartPerishing()
			end
			
			if inst.components.equippable ~= nil then
				inst.components.equippable:Unequip(owner)
			end
		end
	end
end

for k, item in pairs(TUNING.VANITY_MUSHROOM_HEAD_ITEMS) do
	AddPrefabPostInit(item, MushroomHatPostInit)
end

local function RuinsHatPostInit(inst)
	inst.onequipvanity = function(inst, owner, from_ground)
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
	
	inst.onunequipvanity = function(inst, owner)
		if owner ~= nil then
			if inst.components.equippable ~= nil then
				inst.components.equippable:Unequip(owner)
			end
		end
	end
end

AddPrefabPostInit("ruinshat", RuinsHatPostInit)

local function FeatherHatPostInit(inst)
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			local attractor = owner.components.birdattractor
			local birdspawner = _G.TheWorld.components.birdspawner
			
			if inst.components.fueled ~= nil then
				inst.components.fueled:StopConsuming()
				
				if inst.components.no_sewing ~= nil then
					inst.components.fueled.__no_sewing = inst.components.fueled.no_sewing
					inst.components.fueled.no_sewing = true
				end
			end
		
			if attractor then
				attractor.spawnmodifier:RemoveModifier(inst)

				if birdspawner ~= nil then
					birdspawner:ToggleUpdate(true)
				end
			end
		end
	end
	
	inst.onunequipvanity = function(inst, owner)
		if owner ~= nil then
			if inst.components.equippable ~= nil then
				inst.components.equippable:Unequip(owner)
			end
			
			if inst.components.fueled ~= nil then
				if inst.components.fueled.no_sewing ~= nil then
					inst.components.fueled.no_sewing = inst.components.fueled.__no_sewing
				end
			end
		end
	end
end

AddPrefabPostInit("featherhat", FeatherHatPostInit)

local function BeefaloHatPostInit(inst)
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then

			if inst.components.fueled ~= nil then
				inst.components.fueled:StopConsuming()
				
				if inst.components.fueled.no_sewing ~= nil then
					inst.components.fueled.__no_sewing = inst.components.fueled.no_sewing
					inst.components.fueled.no_sewing = true
				end
			end
			
			owner:RemoveTag("beefalo")
		end
	end
	
	inst.onunequipvanity = function(inst, owner)
		if owner ~= nil then
			if inst.components.fueled ~= nil then
				if inst.components.fueled.no_sewing ~= nil then
					inst.components.fueled.no_sewing = inst.components.fueled.__no_sewing
				end
				
				if inst.components.equippable:IsEquipped() then
					inst.components.fueled:StartConsuming()
				end
			end
		
			if inst.components.equippable:IsEquipped() then
				owner:AddTag("beefalo")
			end
		end
	end
end

AddPrefabPostInit("beefalohat", BeefaloHatPostInit)

local function MinerHatPostInit(inst)
	inst.onequipvanity = function(inst, owner, from_ground)
		local skin_build = inst:GetSkinBuild()
		local owner = inst.components.inventoryitem ~= nil 
        and inst.components.inventoryitem:GetGrandOwner() or nil
		
		if owner ~= nil then
			if inst.components.fueled ~= nil then
				inst.components.fueled:StopConsuming()
				
				if inst.components.fueled.accepting ~= nil then
					inst.components.fueled.__accepting = inst.components.fueled.accepting
					inst.components.fueled.accepting = false
				end
			end
			
			if inst._light ~= nil then
				if inst._light:IsValid() then
					inst._light:Remove()
				end
				
				inst._light = nil
			end
			
			if skin_build ~= nil then
				owner:PushEvent("equipskinneditem", inst:GetSkinName())
				owner.AnimState:OverrideItemSkinSymbol("swap_hat", skin_build, "swap_hat_off", inst.GUID, "hat_miner")
			else
				owner.AnimState:OverrideSymbol("swap_hat", "hat_miner", "swap_hat_off")
			end
			
			owner.AnimState:Show("HAT")
			owner.AnimState:Show("HAIR_HAT")
			owner.AnimState:Hide("HAIR_NOHAT")
			owner.AnimState:Hide("HAIR")

			owner.AnimState:Hide("HEAD")
			owner.AnimState:Show("HEAD_HAT")
			owner.AnimState:Show("HEAD_HAT_NOHELM")
			owner.AnimState:Hide("HEAD_HAT_HELM")
		end
	end
	
	inst.onunequipvanity = function(inst, owner)
		if owner ~= nil then
			if inst.components.fueled ~= nil then
				if inst.components.fueled.accepting ~= nil then
					inst.components.fueled.accepting = inst.components.fueled.__accepting
				end
			end
		end
	end
end

AddPrefabPostInit("minerhat", MinerHatPostInit)

local function HiveHatPostInit(inst)
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			if owner.components.sanity ~= nil then
				if owner.components.sanity.neg_aura_absorb ~= nil then
					owner.components.sanity.__neg_aura_absorb = owner.components.sanity.neg_aura_absorb
					owner.components.sanity.neg_aura_absorb = 0
				end
			end
		end
	end
	
	inst.onunequipvanity = function(inst, owner)
		if owner ~= nil then
			if owner.components.sanity ~= nil then
				if owner.components.sanity.neg_aura_absorb ~= nil then
					owner.components.sanity.neg_aura_absorb = 0
				end

				if inst.components.equippable:IsEquipped() then
					owner.components.sanity.neg_aura_absorb = TUNING.ARMOR_HIVEHAT_SANITY_ABSORPTION
				end
			end
		end
	end
end

AddPrefabPostInit("hivehat", HiveHatPostInit)

local function SkeletonHatPostInit(inst)
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			if owner.components.sanity ~= nil then
				owner.components.sanity:SetInducedInsanity(inst, false)
			end
			
			inst:RemoveTag("shadowdominance")
		end
	end
	
	inst.onunequipvanity = function(inst, owner)
		if owner ~= nil then
			if inst.components.equippable ~= nil then
				inst.components.equippable:Unequip(owner)
			end
			
			inst:AddTag("shadowdominance")
		end
	end
end

AddPrefabPostInit("skeletonhat", SkeletonHatPostInit)

local function AntlionHatPostInit(inst)
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			if inst.components.autoterraformer ~= nil then
				inst.components.autoterraformer:StopTerraforming()
			end
			
			inst:RemoveTag("turfhat")
		end
	end
	
	inst.onunequipvanity = function(inst, owner)
		if owner ~= nil then
			if inst.components.equippable ~= nil then
				inst.components.equippable:Unequip(owner)
			end
			
			inst:AddTag("turfhat")
		end
	end
end

AddPrefabPostInit("antlionhat", AntlionHatPostInit)

local function PollyRogersHatPostInit(inst)
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			if inst.components.fueled ~= nil then
				inst.components.fueled:StopConsuming()
				
				if inst.components.fueled.no_sewing ~= nil then
					inst.components.fueled.__no_sewing = inst.components.fueled.no_sewing
					inst.components.fueled.no_sewing = true
				end
			end
			
			if inst.pollytask ~= nil then
				inst.pollytask:Cancel()
				inst.pollytask = nil
			end

			if inst.polly ~= nil then
				inst.polly.flyaway = true
				inst.polly:PushEvent("flyaway")
			end
		end
	end
	
	inst.onunequipvanity = function(inst, owner)
		if owner ~= nil then
			if inst.components.equippable ~= nil then
				inst.components.equippable:Unequip(owner)
			end
			
			if inst.components.fueled ~= nil then
				if inst.components.fueled.no_sewing ~= nil then
					inst.components.fueled.no_sewing = inst.components.fueled.__no_sewing
				end
			end
		end
	end
end

AddPrefabPostInit("polly_rogershat", PollyRogersHatPostInit)

local function MonkeySmallHatPostInit(inst)
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			if inst.components.fueled ~= nil then
				inst.components.fueled:StopConsuming()
				
				if inst.components.fueled.no_sewing ~= nil then
					inst.components.fueled.__no_sewing = inst.components.fueled.no_sewing
					inst.components.fueled.no_sewing = true
				end
			end
			
			owner:RemoveTag("master_crewman")
		end
	end
	
	inst.onunequipvanity = function(inst, owner)
		if owner ~= nil then
			if inst.components.fueled ~= nil then
				if inst.components.fueled.no_sewing ~= nil then
					inst.components.fueled.no_sewing = inst.components.fueled.__no_sewing
				end
				
				if inst.components.equippable:IsEquipped() then
					inst.components.fueled:StartConsuming()
				end
			end
			
			if inst.components.equippable:IsEquipped() then
				owner:AddTag("master_crewman")
			end
		end
	end
end

AddPrefabPostInit("monkey_smallhat", MonkeySmallHatPostInit)

local function MonkeyMediumHatPostInit(inst)
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			if inst.components.fueled ~= nil then
				inst.components.fueled:StopConsuming()
				
				if inst.components.fueled.no_sewing ~= nil then				
					inst.components.fueled.__no_sewing = inst.components.fueled.no_sewing
					inst.components.fueled.no_sewing = true
				end
			end
			
			owner:RemoveTag("boat_health_buffer")
		end
	end
	
	inst.onunequipvanity = function(inst, owner)
		if owner ~= nil then
			if inst.components.fueled ~= nil then
				if inst.components.fueled.no_sewing ~= nil then
					inst.components.fueled.no_sewing = inst.components.fueled.__no_sewing
				end
				
				if inst.components.equippable:IsEquipped() then
					inst.components.fueled:StartConsuming()
				end
			end
			
			if inst.components.equippable:IsEquipped() then
				owner:AddTag("boat_health_buffer")
			end
		end
	end
end

AddPrefabPostInit("monkey_mediumhat", MonkeyMediumHatPostInit)

local function MonocleHatPostInit(inst)
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			if inst.components.fueled ~= nil then
				inst.components.fueled:StopConsuming()
				
				if inst.components.fueled.no_sewing ~= nil then
					inst.components.fueled.__no_sewing = inst.components.fueled.no_sewing
					inst.components.fueled.no_sewing = true
				end
			end
			
			owner:RemoveCameraExtraDistance(inst)
			owner:RemoveTag("scrapmonolevision")
		end
	end
	
	inst.onunequipvanity = function(inst, owner)
		if owner ~= nil then
			if inst.components.fueled ~= nil then
				if inst.components.fueled.no_sewing ~= nil then
					inst.components.fueled.no_sewing = inst.components.fueled.__no_sewing
				end
				
				if inst.components.equippable:IsEquipped() then
					inst.components.fueled:StartConsuming()
				end
			end
			
			if inst.components.equippable:IsEquipped() then
				owner:AddCameraExtraDistance(inst, TUNING.SCRAP_MONOCLE_EXTRA_VIEW_DIST)
				owner:AddTag("scrapmonolevision")
			end
		end
	end
end

AddPrefabPostInit("scrap_monoclehat", MonocleHatPostInit)

local function BatNoseHatPostInit(inst)
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			if inst.components.perishable ~= nil then
				inst.components.perishable:StopPerishing()
			end
			
			if owner.components.debuffable ~= nil then
				owner:RemoveDebuff("hungerregenbuff")
			end
			
			if owner.components.foodmemory ~= nil then
				owner.components.foodmemory:RememberFood("hungerregenbuff")
			end
		end
	end
	
	inst.onunequipvanity = function(inst, owner)
		if owner ~= nil then
			if inst.components.perishable ~= nil then
				if inst.components.equippable:IsEquipped() then
					inst.components.perishable:StartPerishing()
					
					if owner.components.debuffable ~= nil then
						owner:AddDebuff("hungerregenbuff", "hungerregenbuff")
					end
					
					if owner.components.foodmemory ~= nil then
						owner.components.foodmemory:RememberFood("hungerregenbuff")
					end
				end
			end
		end
	end
end

AddPrefabPostInit("batnosehat", BatNoseHatPostInit)

local function DreadstoneHatPostInit(inst)	
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			if inst.regentask ~= nil then
				inst.regentask:Cancel()
				inst.regentask = nil
			end
		end
	end
	
	inst.onunequipvanity = function(inst, owner)
		if owner ~= nil then
			if inst.components.equippable ~= nil then
				inst.components.equippable:Unequip(owner)
			end
		end
	end
end

AddPrefabPostInit("dreadstonehat", DreadstoneHatPostInit)

local function BushHatPostInit(inst)
	local _stopusingbush = UpvalueHacker.GetUpvalue(_G.Prefabs.bushhat.fn, "stopusingbush")
	
	local function stopusingbush(inst, data)
		_stopusingbush(inst, data)
	end
	
	UpvalueHacker.SetUpvalue(_G.Prefabs.bushhat.fn, stopusingbush, "stopusingbush")
	_G.Prefabs.bushhat._stopusingbush = _stopusingbush
	
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			inst:RemoveEventCallback("newstate", stopusingbush, owner)
		end
	end
	
	inst.onunequipvanity = function(inst, owner)
		if owner ~= nil then
			if inst.components.equippable ~= nil then
				inst.components.equippable:Unequip(owner)
			end
		end
	end
end

AddPrefabPostInit("bushhat", BushHatPostInit)

local function PlantRegistryHatPostInit(inst)
	local _stopusingplantregistry = UpvalueHacker.GetUpvalue(_G.Prefabs.plantregistryhat.fn, "stopusingplantregistry")

	local function stopusingplantregistry(inst, data)
		_stopusingplantregistry(inst, data)
	end
	
	UpvalueHacker.SetUpvalue(_G.Prefabs.plantregistryhat.fn, stopusingplantregistry, "stopusingplantregistry")
	_G.Prefabs.plantregistryhat._stopusingplantregistry = _stopusingplantregistry
	
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			inst:RemoveEventCallback("newstate", stopusingplantregistry, owner)
		end
	end
	
	inst.onunequipvanity = function(inst, owner)
		if owner ~= nil then
			if inst.components.equippable ~= nil then
				inst.components.equippable:Unequip(owner)
			end
		end
	end
end

AddPrefabPostInit("plantregistryhat", PlantRegistryHatPostInit)
AddPrefabPostInit("nutrientsgoggleshat", PlantRegistryHatPostInit)

local function SlurperPostInit(inst)
	inst:AddTag("vanity_item_restricted")

	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			if inst.task ~= nil then
				inst.task:Cancel()
			end

			inst._light.Light:Enable(false)
			
			inst.ondetach(owner)
		end
	end
	
	inst.onunequipvanity = function(inst, owner)
		if owner ~= nil then
			if inst.components.equippable ~= nil then
				inst.components.equippable:Unequip(owner)
			end
		end
	end
end

AddPrefabPostInit("slurper", SlurperPostInit)

local function WagpunkHatPostInit(inst)
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			_G.RemoveEventListener(inst, "onattackother")
			
			if inst._wearer ~= nil then
				inst._wearer:set(nil)
			end

			if owner ~= nil and owner.components.combat ~= nil then
				owner.components.combat.externaldamagemultipliers:RemoveModifier(inst)
			end
		end
	end
	
	inst.onunequipvanity = function(inst, owner)
		if owner ~= nil then
			if inst.components.equippable ~= nil then
				inst.components.equippable:Unequip(owner)
			end
		end
	end
end

AddPrefabPostInit("wagpunkhat", WagpunkHatPostInit)

local function RabbitHatPostInit(inst)
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			if inst.components.perishable ~= nil then
				inst.components.perishable:StopPerishing()
			end
	
			owner:RemoveTag("rabbitdisguise")
		end
	end
	
	inst.onunequipvanity = function(inst, owner)
		if owner ~= nil then
			if inst.components.perishable ~= nil then
				inst.components.perishable:StartPerishing()
			end
			
			if inst.components.equippable:IsEquipped() then
				owner:AddTag("rabbitdisguise")
			end
		end
	end
end

AddPrefabPostInit("rabbithat", RabbitHatPostInit)

local function AlterGuardianHatPostInit(inst)
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			if inst._light ~= nil then
				inst._light:Remove()
				inst._light = nil
			end

			if inst._front == nil then
				inst._front = _G.SpawnPrefab("alterguardian_hat_equipped")
				inst._front:OnActivated(owner, true)
			end
			
			if inst._back == nil then
				inst._back = _G.SpawnPrefab("alterguardian_hat_equipped")
				inst._back:OnActivated(owner, false)
			end
			
			owner.AnimState:HideSymbol("swap_hat")

			_G.RemoveEventListener(inst, "sanitydelta")
			_G.RemoveEventListener(inst, "onattackother")
		end
	end
	
	inst.onunequipvanity = function(inst, owner)
		if owner ~= nil then
			if inst.components.equippable ~= nil then
				inst.components.equippable:Unequip(owner)
			end
		end
	end
end

AddPrefabPostInit("alterguardianhat", AlterGuardianHatPostInit)

local function LunarPlantHatPostInit(inst)
	inst:AddTag("vanity_fullhead")
	
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			if owner.components.grue ~= nil then
				owner.components.grue:RemoveImmunity("lunarplanthat")
			end
		end
	end
	
	inst.onunequipvanity = function(inst, owner)
		if owner ~= nil then
			if inst.components.equippable ~= nil then
				inst.components.equippable:Unequip(owner)
			end
		end
	end
end

AddPrefabPostInit("lunarplanthat", LunarPlantHatPostInit)

local function VoidClothHatPostInit(inst)
	inst:AddTag("vanity_fullhead")

	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			inst:RemoveEventCallback("equip", inst._onownerequip, inst._owner)
			inst:RemoveEventCallback("unequip", inst._onownerunequip, inst._owner)
			inst:RemoveEventCallback("attacked", inst._onattacked, inst._owner)
			inst:RemoveEventCallback("onattackother", inst._onattackother, inst._owner)
		end
	end
	
	inst.onunequipvanity = function(inst, owner)
		if owner ~= nil then
			if inst.components.equippable ~= nil then
				inst.components.equippable:Unequip(owner)
			end
		end
	end
end

AddPrefabPostInit("voidclothhat", VoidClothHatPostInit)