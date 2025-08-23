-- Common Dependencies.
local _G           = GLOBAL
local require      = _G.require
local EQUIPSLOTS   = _G.EQUIPSLOTS

require("vs_tuning")

-- TO DO: Fix these items:
-- minerhat (invisible when vanity)

-- alterguardianhat (gives light when vanity)
-- wagpunkhat (gives buff and crashes)
-- inspectacleshat (dont hide when vanity equipped)
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
		
		-- inst:AddTag("vanity_equipped")
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
		
		-- inst:RemoveTag("vanity_equipped")
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
		
		-- inst:AddTag("vanity_equipped")
	end
	
	inst.onunequipvanity = function(inst, owner)
		if owner ~= nil then
			if inst.components.perishable ~= nil then
				inst.components.perishable:StartPerishing()
			end
			
			if inst.components.equippable:IsEquipped() then
				if owner.components.hunger ~= nil then
					owner.components.hunger.burnratemodifiers:SetModifier(inst, TUNING.MUSHROOMHAT_SLOW_HUNGER)
				end
				
				if inst.components.periodicspawner ~= nil then
					inst.components.periodicspawner:Start()
				end
				
				if inst._ismoonspore then
					owner:AddTag("moon_spore_protection")
					inst:ListenForEvent("attacked", inst.mushroom_onattacked_moonspore, owner)
				end
				
				owner:AddTag("spoiler")
			end
		end
		
		-- inst:RemoveTag("vanity_equipped")
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
		
		-- inst:AddTag("vanity_equipped")
	end
	
	inst.onunequipvanity = function(inst, owner)
		if owner ~= nil then
			if inst.components.equippable:IsEquipped() then
				inst.onattach()
			end
		end
		
		-- inst:RemoveTag("vanity_equipped")
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
		
		-- inst:AddTag("vanity_equipped")
	end
	
	inst.onunequipvanity = function(inst, owner)
		if owner ~= nil then
			local attractor = owner.components.birdattractor
			local birdspawner = _G.TheWorld.components.birdspawner
			
			if inst.components.fueled ~= nil then
				if inst.components.no_sewing ~= nil then
					inst.components.fueled.no_sewing = inst.components.fueled.__no_sewing
				end
				
				if inst.components.equippable:IsEquipped() then
					inst.components.fueled:StartConsuming()
				end
			end
		
			if inst.components.equippable:IsEquipped() then
				if attractor then
					attractor.spawnmodifier:SetModifier(inst, TUNING.BIRD_SPAWN_MAXDELTA_FEATHERHAT, "maxbirds")
					attractor.spawnmodifier:SetModifier(inst, TUNING.BIRD_SPAWN_DELAYDELTA_FEATHERHAT.MIN, "mindelay")
					attractor.spawnmodifier:SetModifier(inst, TUNING.BIRD_SPAWN_DELAYDELTA_FEATHERHAT.MAX, "maxdelay")

					if birdspawner ~= nil then
						birdspawner:ToggleUpdate(true)
					end
				end
			end
		end
		
		-- inst:RemoveTag("vanity_equipped")
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
		
		-- inst:AddTag("vanity_equipped")
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
		
		-- inst:RemoveTag("vanity_equipped")
	end
end

AddPrefabPostInit("beefalohat", BeefaloHatPostInit)

-----------------------------------------------------------------------------------------------

-- MINERHAT

-----------------------------------------------------------------------------------------------

local function HiveHatPostInit(inst)
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			if owner.components.sanity ~= nil then
				if owner.components.sanity.neg_aura_absorb ~= nil then
					owner.components.sanity.__neg_aura_absorb = owner.components.sanity.neg_aura_absorb	
					owner.components.sanity.neg_aura_absorb = 0
				end
			end
			
			owner:AddTag("hive_sanity_aura")
		end
		
		-- inst:AddTag("vanity_equipped")
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
		
		-- inst:RemoveTag("vanity_equipped")
	end
end

AddPrefabPostInit("hivehat", HiveHatPostInit)

local function SkeletonHatPostInit(inst)
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			if owner.components.sanity ~= nil then
				owner.components.sanity:SetInducedInsanity(inst, false)
				owner:RemoveTag("shadowdominance")
			end
		end
		
		-- inst:AddTag("vanity_equipped")
	end
	
	inst.onunequipvanity = function(inst, owner)
		if owner ~= nil then
			if inst.components.equippable:IsEquipped() then
				if owner.components.sanity ~= nil then
					owner.components.sanity:SetInducedInsanity(inst, true)
					owner:AddTag("shadowdominance")
				end
			end
		end
		
		-- inst:RemoveTag("vanity_equipped")
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
		
		inst:AddTag("vanity_equipped")
	end
	
	inst.onunequipvanity = function(inst, owner)
		if owner ~= nil then	
			if inst.components.equippable:IsEquipped() then
				if inst.components.autoterraformer ~= nil then
					inst.components.autoterraformer:StartTerraforming()
				end
			end
			
			inst:AddTag("turfhat")
		end
		
		-- inst:RemoveTag("vanity_equipped")
	end
end

AddPrefabPostInit("antlionhat", AntlionHatPostInit)

local function PollyRogersHatPostInit(inst)
	
end

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
		
		-- inst:AddTag("vanity_equipped")
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
		
		-- inst:RemoveTag("vanity_equipped")
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
		
		-- inst:AddTag("vanity_equipped")
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
		
		-- inst:RemoveTag("vanity_equipped")
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
		
		-- inst:AddTag("vanity_equipped")
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
		
		-- inst:RemoveTag("vanity_equipped")
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
		
		-- inst:AddTag("vanity_equipped")
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
		
		-- inst:RemoveTag("vanity_equipped")
	end
end

AddPrefabPostInit("batnosehat", BatNoseHatPostInit)