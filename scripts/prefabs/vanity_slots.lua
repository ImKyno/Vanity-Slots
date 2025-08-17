-- This is a hidden prefab attached to the player working as a container.
-- It's basically Wilson's beard but for clothing items!
local assets =
{
	Asset("ANIM", "anim/backpack.zip"),
	Asset("ANIM", "anim/swap_krampus_sack.zip"),
	Asset("ANIM", "anim/ui_chest_3x1.zip"),
}

-- TO DO: Fix some persisting effects i.e: alterguardianhat light, minerhat light, ruinshat forcefield, amulet health regen, etc.
-- TO DO: Fix items disappearing on load.
-- TO DO: Fix items not unequipping. --- DONE.
-- TO DO: Fix real items not re-equipping when vanity items are unequipped. -- DONE.
-- TO DO: Fix vanity items not re-equipping when real items are unequipped/equipped.
-- TO DO: Make way to equip backpacks.
-- TO DO: Make way to prevent equipped containers in vanity slot to hold items. --- DONE.
-- TO DO: Items that produce light i.e: minerhat, lantern, etc. should always be off when held.
-- TO DO: Some items don't have onequiptomodelfn, need to make one for them.

local function OnEquipVanity(inst, data)
	local slots = EQUIPSLOTS.HANDS or EQUIPSLOTS.BODY or EQUIPSLOTS.HEAD
	
	if data.eslot == slots and data.item ~= nil then
		
	end
end

local function OnUnequipVanity(inst, data)
	local slots = EQUIPSLOTS.HANDS or EQUIPSLOTS.BODY or EQUIPSLOTS.HEAD
	
	if data.eslot == slots and data.item ~= nil then
		
	end
end

local function ShowEquippedItem(inst, data, owner)
	local owner = inst.components.inventoryitem.owner or inst.components.inventoryitem:GetGrandOwner()
	local vanityitem = data.item
	local vanityslot = data.slot
	
	if owner ~= nil then
		if not owner:HasTag("equipmentmodel") then
			owner:AddTag("equipmentmodel")
		end
	
		if vanityitem ~= nil then
			vanityitem.components.equippable:Equip(owner)
			if vanityitem.components.equippable.onequiptomodelfn ~= nil then
				vanityitem.components.equippable.onequiptomodelfn(vanityitem, owner)
			end

			if vanityitem.components.fueled ~= nil then
				vanityitem.components.fueled:StopConsuming()
			end
		
			if vanityitem.components.perishable ~= nil then
				vanityitem.components.perishable:StopPerishing()
			end

			if vanityitem.components.container ~= nil then
				vanityitem.components.container._restrictedtag = vanityitem.components.container.restrictedtag
				vanityitem.components.container.restrictedtag = "steammocking"
				
				vanityitem.components.container:DropEverything()
				vanityitem.components.container:Close()
			end

			owner:RemoveTag("equipmentmodel")
		end
	end
end

local function HideEquippedItem(inst, data, owner)
	local owner = inst.components.inventoryitem.owner or inst.components.inventoryitem:GetGrandOwner()
	local vanityitem = data.prev_item
	local vanityslot = data.slot
	
	local realhand = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
	local realbody = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
	local realhead = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
	
	if owner ~= nil then
		if owner:HasTag("equipmentmodel") then
			owner:RemoveTag("equipmentmodel")
		end

		if vanityitem ~= nil and vanityitem.components.equippable ~= nil then
			vanityitem.components.equippable:Unequip(owner)

			if realhand ~= nil then
				realhand.components.equippable:Unequip(owner)
				realhand.components.equippable:Equip(owner)
			end

			if vanityitem.components.container ~= nil then
				if vanityitem.components.container.restrictedtag == "steammocking" then
					vanityitem.components.container.restrictedtag = nil
				else
					vanityitem.components.container.restrictedtag = vanityitem.components.container._restrictedtag
				end
			end
		end
	end
end

local function OnEquip(inst, owner)
	inst.components.container:Open(owner)
end

local function OnUnequip(inst, owner)
	inst.components.container:Close(owner)
	
	inst:RemoveEventCallback("itemget", inst.ShowEquippedItem, owner)
	inst:RemoveEventCallback("itemlose", inst.HideEquippedItem, owner)
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("backpack1")
	inst.AnimState:SetBuild("swap_krampus_sack")
	inst.AnimState:PlayAnimation("anim")

	inst:AddTag("vanity_slots")

	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst)
			inst.replica.container:WidgetSetup("vanity_slots")
		end
		
		return inst
	end

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.cangoincontainer = false

	inst:AddComponent("equippable")
	inst.components.equippable.equipslot = EQUIPSLOTS.VANITY
	inst.components.equippable:SetPreventUnequipping(true)
	inst.components.equippable:SetOnEquip(OnEquip)
	inst.components.equippable:SetOnUnequip(OnUnequip)

	inst:AddComponent("container")
	inst.components.container:WidgetSetup("vanity_slots") 
	inst.components.container.stay_open_on_hide = true
	
	inst.ShowEquippedItem = ShowEquippedItem
	inst.HideEquippedItem = HideEquippedItem
	
	inst:ListenForEvent("itemget", inst.ShowEquippedItem)
	inst:ListenForEvent("itemlose", inst.HideEquippedItem)

    return inst
end

return Prefab("vanity_slots", fn, assets)