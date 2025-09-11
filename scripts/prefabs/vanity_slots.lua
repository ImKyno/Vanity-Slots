-- This is a hidden prefab attached to the player working as a container.
-- It's basically Wilson's beard but for equippable items!
local assets =
{
	Asset("ANIM", "anim/backpack.zip"),
	Asset("ANIM", "anim/cutgrass.zip"),
	Asset("ANIM", "anim/swap_krampus_sack.zip"),
	Asset("ANIM", "anim/ui_chest_3x1.zip"),
}

-- TO DO: Fix cant move item from containers when vanity is equipped.
-- TO DO: Fix ghost item when unequipping backpacks. // Temporary solution: spawn ghost item and remove it immediately.
-- TO DO: Swap vanity item with real item.

local EQUIPSLOTS_VANITYSLOTS_INDEX = TUNING.EQUIPSLOTS_VANITYSLOTS_INDEX
local INVERTED_EQUIPSLOTS_VANITYSLOTS_INDEX = table.invert(EQUIPSLOTS_VANITYSLOTS_INDEX)

local function ShowEquippedItem(inst, data, owner)
	local owner = inst.components.inventoryitem.owner or inst.components.inventoryitem:GetGrandOwner()
	local vanityitem = data.item
	local vanityslot = data.slot

	if owner ~= nil then
		if vanityitem ~= nil then
			vanityitem.components.equippable:Equip(owner)
			
			local realslot = INVERTED_EQUIPSLOTS_VANITYSLOTS_INDEX[vanityslot]
			local realitem = owner.components.inventory:GetEquippedItem(realslot)

			if realitem and realitem.prefab == vanityitem.prefab then 
				-- print("VANITY SLOTS: VANITY/EQUIPPED ITEM ARE THE SAME.")
				-- print("VANITY SLOTS: YOU SHOULDN'T BE DOING THAT.")
				if vanityitem.onequipvanity ~= nil then
					vanityitem.onequipvanity(vanityitem, inst)
				end
			else
				ApplyVanityEffects(vanityitem, owner)
			end
			
			if realitem ~= nil then
				RemoveRealItemsFX(realitem, owner)
			end
			
			ApplyOverlayEffects(vanityitem, realitem, owner)
			ApplyContainerEffects(vanityitem, realitem, owner)
		end
	end
end

local function HideEquippedItem(inst, data, owner)
	local owner = inst.components.inventoryitem.owner or inst.components.inventoryitem:GetGrandOwner()
	local vanityslot = data.slot
	local vanityitem = data.prev_item
	
	local realslot = INVERTED_EQUIPSLOTS_VANITYSLOTS_INDEX[vanityslot]
	local realitem = owner ~= nil and owner.components.inventory:GetEquippedItem(realslot)
	
	if owner ~= nil then
		if vanityslot ~= nil then
			if vanityitem ~= nil and vanityitem.components.equippable ~= nil then
				if vanityitem:HasTag("vanity_equipped") then
					vanityitem:RemoveTag("vanity_equipped")
				end
				
				if vanityitem:HasTag("vanity_item_restricted") then
					local currentowner = vanityitem.components.inventoryitem:GetGrandOwner()
					local ghostitem = SpawnPrefab("vanity_ghostitem")
					
					if currentowner ~= nil and currentowner.components.inventory ~= nil then
						currentowner.components.inventory:DropItem(vanityitem)
						currentowner.components.inventory:SetActiveItem(ghostitem)

						vanityitem.components.inventoryitem.cangoincontainer = vanityitem.components.inventoryitem.__cangoincontainer
						vanityitem.components.inventoryitem.__cangoincontainer = nil
					end
				else
					vanityitem.components.equippable:Unequip(owner)
				end
				
				if vanityitem.onunequipvanity ~= nil then
					vanityitem.onunequipvanity(vanityitem, owner)
				else
					RemoveVanityEffects(vanityitem, owner)
				end

				RemoveContainerEffects(vanityitem, owner)
				RemoveOverlayEffects(vanityitem, realitem, owner)
				
				-- Show any real item if its equipped.
				if realitem ~= nil and realitem.components.equippable ~= nil
				and not realitem.components.playerfloater then -- Can't unequip floater.
					realitem.components.equippable:Unequip(owner)
					realitem.components.equippable:Equip(owner)
					
					ApplyRealItemsFX(realitem, owner)
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
	
	-- We get unequipped during seamlessplayerswap, don't remove callback here.
	-- inst:RemoveEventCallback("itemget", inst.ShowEquippedItem)
	-- inst:RemoveEventCallback("itemlose", inst.HideEquippedItem)
end

local function OnDropped(inst)
	if inst:IsValid() then
		inst.components.container:DropEverything()
		inst:Remove()
	end
end

local function OnEntityRemove(inst, owner)
	inst.components.container:Close(owner)

	inst:RemoveEventCallback("itemget", ShowEquippedItem)
	inst:RemoveEventCallback("itemlose", HideEquippedItem)
	inst:RemoveEventCallback("ondropped", OnDropped)
end

local function InitVanitySlots(inst, owner)
	local owner = inst.components.inventoryitem.owner or inst.components.inventoryitem:GetGrandOwner()
	
	if inst.components.container ~= nil then
		for slot, item in pairs(inst.components.container.slots) do
			ShowEquippedItem(inst, {item = item, slot = slot}, owner)
		end
	end
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
	inst:AddTag("nosteal")

	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst)
			inst.replica.container:WidgetSetup("vanity_slots")
		end
		
		return inst
	end

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.cangoincontainer = false
	inst.components.inventoryitem.keepondrown = true

	inst:AddComponent("equippable")
	inst.components.equippable.equipslot = EQUIPSLOTS.VANITY
	inst.components.equippable:SetPreventUnequipping(false) -- if true will prevent transfering items during seamlessplayerswap.
	inst.components.equippable:SetOnEquip(OnEquip)
	inst.components.equippable:SetOnUnequip(OnUnequip)

	inst:AddComponent("container")
	inst.components.container:WidgetSetup("vanity_slots")
	inst.components.container.stay_open_on_hide = true

	inst.ShowEquippedItem = ShowEquippedItem
	inst.HideEquippedItem = HideEquippedItem
	inst.RefreshEquippedItem = InitVanitySlots

	inst:ListenForEvent("itemget", ShowEquippedItem)
	inst:ListenForEvent("itemlose", HideEquippedItem)
	
	inst:ListenForEvent("ondropped", OnDropped)
	inst:ListenForEvent("onremove", OnEntityRemove)

	-- Need this because stupid OnLoad won't call equip event.
	inst:DoTaskInTime(0, InitVanitySlots)

    return inst
end

-- WHAT IS this? Its a stupid way to fix a bug.
-- Equipping items that can't go inside the inventory aka backpacks and such
-- when unequipping them you'll briefly see a ghost item of them.
local function ghostfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("cutgrass")
	inst.AnimState:SetBuild("cutgrass")
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("nosteal")
	inst:AddTag("notarget")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inventoryitem")

	inst:DoTaskInTime(0, inst.Remove) -- Kill self before player can interect with us.

	return inst
end

return Prefab("vanity_slots", fn, assets),
Prefab("vanity_ghostitem", ghostfn, assets)