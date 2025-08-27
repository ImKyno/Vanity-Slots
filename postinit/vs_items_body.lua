-- Common Dependencies.
local _G           = GLOBAL
local require      = _G.require
local EQUIPSLOTS   = _G.EQUIPSLOTS

require("vs_tuning")

local function RedAmuletPostInit(inst)
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			if inst.task ~= nil then
				inst.task:Cancel()
				inst.task = nil
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

AddPrefabPostInit("amulet", RedAmuletPostInit)

local function BlueAmuletPostInit(inst)
	inst.freezefn = function(attacked, data)
		if data ~= nil and data.attacker ~= nil and data.attacker.components.freezable ~= nil then
			data.attacker.components.freezable:AddColdness(0.67)
			data.attacker.components.freezable:SpawnShatterFX()
			inst.components.fueled:DoDelta(-0.03 * inst.components.fueled.maxfuel)
		end
	end
	
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			inst:RemoveEventCallback("attacked", inst.freezefn, owner)

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
		end
	end
end

AddPrefabPostInit("blueamulet", BlueAmuletPostInit)

local function PurpleAmuletPostInit(inst)
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil and owner.components.sanity ~= nil then
			owner.components.sanity:SetInducedInsanity(inst, false)
			
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
		end
	end
end

AddPrefabPostInit("purpleamulet", PurpleAmuletPostInit)

local function OrangeAmuletPostInit(inst)
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			if inst.task ~= nil then
				inst.task:Cancel()
				inst.task = nil
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

AddPrefabPostInit("orangeamulet", OrangeAmuletPostInit)

local function GreenAmuletPostInit(inst)
	inst.onitembuild = function(owner, data)
		if not (data ~= nil and data.discounted == false) then
			inst.components.finiteuses:Use(1)
		end
	end
	
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

AddPrefabPostInit("greenamulet", GreenAmuletPostInit)

local function YellowAmuletPostInit(inst)
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			if inst.components.equippable.onequiptomodelfn ~= nil then
				inst.components.equippable.onequiptomodelfn(inst, owner)
			end
			
			if inst.components.fueled.accepting ~= nil then
				inst.components.fueled.__accepting = inst.components.fueled.accepting
				inst.components.fueled.accepting = false
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

AddPrefabPostInit("yellowamulet", YellowAmuletPostInit)

local function ArmorBramblePostInit(inst)
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			inst:RemoveEventCallback("blocked", inst._onblocked, owner)
			inst:RemoveEventCallback("attacked", inst._onblocked, owner)
			inst:RemoveEventCallback("onattackother", inst._onattackother, owner)

			inst._hitcount = nil
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

AddPrefabPostInit("armor_bramble", ArmorBramblePostInit)