-- Common Dependencies.
local _G            = GLOBAL
local require       = _G.require
local EQUIPSLOTS    = _G.EQUIPSLOTS
local UpvalueHacker = require("vs_upvaluehacker")

require("vs_tuning")

local function TorchPostInit(inst)
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			if inst.components.equippable.onequiptomodelfn ~= nil then
				inst.components.equippable.onequiptomodelfn(inst, owner)
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

AddPrefabPostInit("torch", TorchPostInit)

local function LanternPostInit(inst)
	inst:AddTag("vanity_lantern")

	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then			
			if inst.components.fueled ~= nil then
				inst.components.fueled:StopConsuming()
				
				if inst.components.fueled.accepting ~= nil then
					inst.components.fueled.__accepting = inst.components.fueled.accepting
					inst.components.fueled.accepting = false
				end
			end
			
			if inst.components.equippable.onequiptomodelfn ~= nil then
				inst.components.equippable.onequiptomodelfn(inst, owner)
			end
			
			owner.AnimState:Hide("LANTERN_OVERLAY")
		end
	end
	
	inst.onunequipvanity = function(inst, owner)
		if owner ~= nil then
			if inst.components.equippable ~= nil then
				inst.components.equippable:Unequip(owner)
			end
			
			if inst.components.fueled ~= nil then
				if inst.components.fueled.accepting ~= nil then
					inst.components.fueled.accepting = inst.components.fueled.__accepting
				end
			end
		end
	end
end

AddPrefabPostInit("lantern", LanternPostInit)

local function RedLanternPostInit(inst)
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			if inst.components.equippable.onequiptomodelfn ~= nil then
				inst.components.equippable.onequiptomodelfn(inst, owner)
			end
			
			if inst.components.fueled ~= nil then
				inst.components.fueled:StopConsuming()
				
				if inst.components.fueled.accepting ~= nil then
					inst.components.fueled.__accepting = inst.components.fueled.accepting
					inst.components.fueled.accepting = false
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
				if inst.components.fueled.accepting ~= nil then
					inst.components.fueled.accepting = inst.components.fueled.__accepting
				end
			end
		end
	end
end

AddPrefabPostInit("redlantern", RedLanternPostInit)
AddPrefabPostInit("yots_redlantern", RedLanternPostInit)

local function ThuriblePostInit(inst)
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			if inst.components.fueled ~= nil then
				inst.components.fueled:StopConsuming()
				
				if inst.components.fueled.accepting ~= nil then
					inst.components.fueled.__accepting = inst.components.fueled.accepting
					inst.components.fueled.accepting = false
				end
			end
		end
		
		inst:RemoveTag("shadowlure")
	end
	
	inst.onunequipvanity = function(inst, owner)
		if owner ~= nil then
			if inst.components.equippable ~= nil then
				inst.components.equippable:Unequip(owner)
			end
			
			if inst.components.fueled ~= nil then
				if inst.components.fueled.accepting ~= nil then
					inst.components.fueled.accepting = inst.components.fueled.__accepting
				end
			end
		end
	end
end

AddPrefabPostInit("thurible", ThuriblePostInit)

local function MiniFanPostInit(inst)
	inst._onlocomote = function(owner)
		if owner.components.locomotor.wantstomoveforward then
			if not inst.components.fueled.consuming then
				inst.components.fueled:StartConsuming()
				inst.components.insulator:SetInsulation(TUNING.INSULATION_SMALL)
				inst.components.heater:SetThermics(false, true)
				
				if inst._wheel ~= nil then
					inst._wheel:SetSpinning(true)
				end
			end
		elseif inst.components.fueled.consuming then
			inst.components.fueled:StopConsuming()
			inst.components.insulator:SetInsulation(0)
			inst.components.heater:SetThermics(false, false)
			
			if inst._wheel ~= nil then
				inst._wheel:SetSpinning(false)
			end
		end
	end

	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			inst:RemoveEventCallback("locomote", inst._onlocomote, owner)
			inst._wheel:SetSpinning(true)
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

AddPrefabPostInit("minifan", MiniFanPostInit)

local function NightStickPostInit(inst)
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			if inst.components.equippable.onequiptomodelfn ~= nil then
				inst.components.equippable.onequiptomodelfn(inst, owner)
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

AddPrefabPostInit("nightstick", NightStickPostInit)

local function BalloonSpeedPostInit(inst)
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			if inst.components.fueled ~= nil then
				inst.components.fueled:StopConsuming()
			end
		end
	end
	
	inst.onunequipvanity = function(inst, owner)
		if owner ~= nil then
			if inst.components.equippable ~= nil then
				inst.components.equippable:Unequip(owner)
			end
			
			if inst.components.fueled ~= nil then
				inst.components.fueled:StartConsuming()
			end
		end
	end
end

AddPrefabPostInit("balloonspeed", BalloonSpeedPostInit)

local function LighterPostInit(inst)
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			if inst.components.equippable.onequiptomodelfn ~= nil then
				inst.components.equippable.onequiptomodelfn(inst, owner)
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

AddPrefabPostInit("lighter", LighterPostInit)

local function ShieldPostInit(inst)
	inst:AddTag("vanity_shield")
	
	inst.onunequipvanity = function(inst, owner)
		if owner ~= nil then
			if inst.components.equippable ~= nil then
				inst.components.equippable:Unequip(owner)
			end
		end
	end
end

AddPrefabPostInit("shieldofterror", ShieldPostInit)
AddPrefabPostInit("wathgrithr_shield", ShieldPostInit)

local function BernieInactivePostInit(inst)
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			if inst.components.equippable.onequiptomodelfn ~= nil then
				inst.components.equippable.onequiptomodelfn(inst, owner)
			end
			
			if inst.components.fueled ~= nil then
				if inst.components.fueled.no_sewing ~= nil then
					inst.components.fueled.__no_sewing = inst.components.fueled.no_sewing
					inst.components.fueled.no_sewing = true
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

AddPrefabPostInit("bernie_inactive", BernieInactivePostInit)

local function VoidClothUmbrellaPostInit(inst)
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			if inst.components.equippable.onequiptomodelfn ~= nil then
				inst.components.equippable.onequiptomodelfn(inst, owner)
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

AddPrefabPostInit("voidcloth_umbrella", VoidClothUmbrellaPostInit)