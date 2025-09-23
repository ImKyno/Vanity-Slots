-- Common Dependencies.
local _G            = GLOBAL
local require       = _G.require
local EQUIPSLOTS    = _G.EQUIPSLOTS
local UpvalueHacker = require("vs_upvaluehacker")

require("vs_tuning")

local function WinonaTelebrellaPostInit(inst)
	inst:AddTag("vanity_teleporter")
end

AddPrefabPostInit("winona_telebrella", WinonaTelebrellaPostInit)

local function SlingshotItemsPostInit(inst)
	inst:AddTag("vanity_slingshot")
end

for k, item in pairs(TUNING.VANITY_SLINGSHOT_ITEMS) do
	AddPrefabPostInit(item, SlingshotItemsPostInit)
end

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
			if inst._wheel ~= nil then
				inst._wheel:SetSpinning(true)
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

local function BalloonsPostInit(inst)
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			if inst.components.fueled ~= nil then
				inst.components.fueled:StopConsuming()
			end

			if inst.onownerattackedfn ~= nil then
				inst:RemoveEventCallback("attacked", inst.onownerattackedfn, owner)
				inst.onownerattackedfn = nil
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

AddPrefabPostInit("balloon", BalloonsPostInit)
AddPrefabPostInit("balloonparty", BalloonsPostInit)

local function BalloonSpeedPostInit(inst)
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			if inst.components.fueled ~= nil then
				inst.components.fueled:StopConsuming()
			end
			
			if inst.onownerattackedfn ~= nil then
				inst:RemoveEventCallback("attacked", inst.onownerattackedfn, owner)
				inst.onownerattackedfn = nil
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

local function PropSignPostInit(inst)
	inst:AddTag("vanity_item_restricted")

	inst.onpreequipvanity = function(inst, owner, from_ground)
		inst.components.inventoryitem.__cangoincontainer = inst.components.inventoryitem.cangoincontainer
		inst.components.inventoryitem.cangoincontainer = true
	end

	inst.onequipvanity = function(inst, owner, from_ground)
		inst:AddTag("vanity_equipped")
	end
	
	inst.onunequipvanity = function(inst, owner)
		if owner ~= nil then
			if inst.components.equippable ~= nil then
				inst.components.equippable:Unequip(owner)
			end
		end

		inst:RemoveTag("vanity_equipped")
	end
end

AddPrefabPostInit("propsign", PropSignPostInit)

local function ShadowBattleAxePostInit(inst)
	local _OnBroken = UpvalueHacker.GetUpvalue(_G.Prefabs.shadow_battleaxe.fn, "OnBroken")
	
	local function OnBroken(inst)
		local owner = inst.components.inventoryitem:GetGrandOwner() or nil
		local vanityslots = owner ~= nil and owner.components.inventory ~= nil and 
		owner.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY) or nil
	
		if owner ~= nil and inst:HasTag("vanity_equipped") then
			if vanityslots ~= nil then
				local broken_item = vanityslots.components.container:RemoveItemBySlot(1)
			
				if broken_item ~= nil then
					broken_item.prevcontainer = nil
					broken_item.prevslot = nil
					
					if owner.components.inventory ~= nil then
						owner.components.inventory:GiveItem(broken_item, nil, owner:GetPosition())
					else
						vanityslots.components.container:DropItem(broken_item)
					end
				end
			end
		end
		
		_OnBroken(inst)
	end
	
	UpvalueHacker.SetUpvalue(_G.Prefabs.shadow_battleaxe.fn, OnBroken, "OnBroken")
	_G.Prefabs.shadow_battleaxe._OnBroken = _OnBroken
end

AddPrefabPostInit("shadow_battleaxe", ShadowBattleAxePostInit)

local function WalkingStickPostInit(inst)
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			if inst.components.fueled ~= nil then
				inst.components.fueled:StopConsuming()
				
				if inst.components.fueled.no_sewing ~= nil then
					inst.components.fueled.__no_sewing = inst.components.fueled.no_sewing
					inst.components.fueled.no_sewing = true
				end
			end
	
			if inst._owner ~= nil then
				inst._owner = owner
				inst:RemoveEventCallback("locomote", inst._onlocomote, inst._owner)
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

AddPrefabPostInit("walking_stick", WalkingStickPostInit)