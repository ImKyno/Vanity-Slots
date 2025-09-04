-- Common Dependencies.
local _G            = GLOBAL
local require       = _G.require
local EQUIPSLOTS    = _G.EQUIPSLOTS
local UpvalueHacker = require("vs_upvaluehacker")

require("vs_tuning")

local function RestrictedItemsPostInit(inst)
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

for k, item in pairs(TUNING.VANITY_RESTRICTED_ITEMS) do
	AddPrefabPostInit(item, RestrictedItemsPostInit)
end

local function BodyPillowPostInit(inst)
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			inst:RemoveEventCallback("blocked", inst._on_blocked, owner)
			inst:RemoveEventCallback("attacked", inst._on_blocked, owner)
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

for k, item in pairs(TUNING.VANITY_PILLOW_BODY_ITEMS) do
	AddPrefabPostInit(item, BodyPillowPostInit)
end

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
			
			if inst.components.fueled ~= nil then
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

local function ArmorDragonflyPostInit(inst)
	local OnBlocked = UpvalueHacker.GetUpvalue(_G.Prefabs.armordragonfly.fn, "onequip", "OnBlocked")

	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			inst:RemoveEventCallback("blocked", OnBlocked, owner)
			inst:RemoveEventCallback("attacked", OnBlocked, owner)
			
			if owner.components.health ~= nil then
				owner.components.health.externalfiredamagemultipliers:RemoveModifier(inst)
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

AddPrefabPostInit("armordragonfly", ArmorDragonflyPostInit)

local function ArmorSlurperPostInit(inst)
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			if inst.components.equippable.onequiptomodelfn ~= nil then
				inst.components.equippable.onequiptomodelfn(inst, owner)
			end
			
			if inst.components.fueled ~= nil then
				if inst.components.fueled.accepting ~= nil then
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

AddPrefabPostInit("armorslurper", ArmorSlurperPostInit)

local function ArmorSnurtleShellPostInit(inst)
	local OnBlocked = UpvalueHacker.GetUpvalue(_G.Prefabs.armorsnurtleshell.fn, "onequip", "OnBlocked")
	local ProtectionLevels = UpvalueHacker.GetUpvalue(_G.Prefabs.armorsnurtleshell.fn, "onequip", "ProtectionLevels")
	
	inst.symbolname = "armor_slurtleshell" -- Required for stategraph.

	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			inst:RemoveEventCallback("blocked", OnBlocked, owner)
			inst:RemoveEventCallback("newstate", ProtectionLevels, owner)
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

AddPrefabPostInit("armorsnurtleshell", ArmorSnurtleShellPostInit)

local function BeargerVestPostInit(inst)
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			if inst.components.equippable.onequiptomodelfn ~= nil then
				inst.components.equippable.onequiptomodelfn(inst, owner)
			end
			
			if inst.components.fueled ~= nil then
				if inst.components.fueled.accepting ~= nil then
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

AddPrefabPostInit("beargervest", BeargerVestPostInit)

local function OneManBandPostInit(inst)
	inst.symbolname = "armor_onemanband" -- Required for stategraph.

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

AddPrefabPostInit("onemanband", OneManBandPostInit)

local function ArmorCarrotLurePostInit(inst)
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			if inst.components.equippable.onequiptomodelfn ~= nil then
				inst.components.equippable.onequiptomodelfn(inst, owner)
			end
			
			if inst.components.perishable ~= nil then
				inst.components.perishable:StopPerishing()
			end
		end
	end
	
	inst.onunequipvanity = function(inst, owner)
		if owner ~= nil then
			if inst.components.equippable ~= nil then
				inst.components.equippable:Unequip(owner)
			end
			
			if inst.components.perishable ~= nil then
				inst.components.perishable:StartPerishing()
			end
		end
	end
end

AddPrefabPostInit("armor_carrotlure", ArmorCarrotLurePostInit)

local function ArmorDreadstonePostInit(inst)	
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

AddPrefabPostInit("armordreadstone", ArmorDreadstonePostInit)

local function ArmorLunarPlantPostInit(inst)
	local _OnReflectDamage = UpvalueHacker.GetUpvalue(_G.Prefabs.armor_lunarplant.fn, "OnReflectDamage")

	local function OnReflectDamage(inst, ...)
		_OnReflectDamage(inst, ...)
	end
	
	UpvalueHacker.SetUpvalue(_G.Prefabs.armor_lunarplant.fn, OnReflectDamage, "OnReflectDamage")
	_G.Prefabs.armor_lunarplant._OnReflectDamage = _OnReflectDamage

	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			inst:RemoveEventCallback("onreflectdamage", OnReflectDamage, owner)
			
			if inst._onblocked ~= nil then
				inst:RemoveEventCallback("attacked", inst._onblocked, owner)
				inst:RemoveEventCallback("blocked", inst._onblocked, owner)
			end
			
			if inst._onattackother ~= nil then
				inst:RemoveEventCallback("onattackother", inst._onattackother, owner)
				inst._hitcount = nil
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

AddPrefabPostInit("armor_lunarplant", ArmorLunarPlantPostInit)
AddPrefabPostInit("armor_lunarplant_husk", ArmorLunarPlantPostInit)

local function ArmorVoidClothPostInit(inst)
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			if owner.components.sanity ~= nil then
				owner.components.sanity.neg_aura_modifiers:RemoveModifier(inst)
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

AddPrefabPostInit("armor_voidcloth", ArmorVoidClothPostInit)

local function ArmorWagPunkPostInit(inst)
	inst.onequipvanity = function(inst, owner, from_ground)
		if owner ~= nil then
			inst:RemoveEventCallback("onattackother", inst.OnAttack, owner)
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

AddPrefabPostInit("armorwagpunk", ArmorWagPunkPostInit)