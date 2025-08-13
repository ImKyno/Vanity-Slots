-- This is a hidden prefab attached to the player working as a container.
-- It's basically Wilson's beard but for clothing items!
local assets =
{
	Asset("ANIM", "anim/backpack.zip"),
	Asset("ANIM", "anim/swap_krampus_sack.zip"),
	Asset("ANIM", "anim/ui_chest_3x1.zip"),
}

-- TO DO: Fix some persisting effects i.e: alterguardianhat light, minerhat light, ruinshat forcefield, amulet health regen, etc.
-- TO DO: Fix items disappearing onload.
-- TO DO: Make way to equip backpacks.
-- TO DO: Make way to prevent equipped containers in vanity slot to hold items.
-- TO DO: Allow heavy objects i.e statues as vanity (?)
-- TO DO: Items that produce light i.e: minerhat, lantern, etc. should always be off when held.
-- TO DO: Some items don't have onequiptomodelfn, need to make one for them.

local function ShowEquippedItem(inst, data, owner)
	local owner = inst.components.inventoryitem.owner or inst.components.inventoryitem:GetGrandOwner()
	print("VANITY SLOTS [SHOW ITEM]: FOUND OWNER:", owner)

	local hand = inst.components.container:GetItemInSlot(1)
	local body = inst.components.container:GetItemInSlot(2)
	local head = inst.components.container:GetItemInSlot(3)
	
	if hand ~= nil and owner ~= nil then
		print("VANITY SLOTS [SHOW ITEM]: EQUIPPED [HAND] ITEM:", hand, "OWNER:", owner)
		if hand.components.equippable.onequiptomodelfn then
			hand.components.equippable:Equip(owner)
			hand.components.equippable.onequiptomodelfn(hand, owner)
		end
		
		-- Make them last forever for *aesthetics* A bit op? Yeah, but you're using a mod that gives you 3 extra slots anyway.
		if hand.components.fueled ~= nil then
			hand.components.fueled:StopConsuming()
		end
		
		if hand.components.perishable ~= nil then
			hand.components.perishable:StopPerishing()
		end
		
		-- You wanted to carry two krampus sacks full of items? 💀💀
		-- Nah buddy, you can't have containers with stuff inside. :steammocking:
		if hand.components.container ~= nil then
			hand.components.container:DropEverything()
			hand.components.container:Close()
		end

		inst.vanity_hand_equipped = true
	end
	
	if body ~= nil and owner ~= nil then
		print("VANITY SLOTS [SHOW ITEM]: EQUIPPED [BODY] ITEM:", body, "OWNER:", owner)
		owner:AddTag("equipmentmodel")
		if body.components.equippable.onequiptomodelfn then
			body.components.equippable:Equip(owner)
			body.components.equippable.onequiptomodelfn(body, owner)
		end
		owner:RemoveTag("equipmentmodel")
		
		if body.components.fueled ~= nil then
			body.components.fueled:StopConsuming()
		end
		
		if body.components.perishable ~= nil then
			body.components.perishable:StopPerishing()
		end
		
		if body.components.container ~= nil then
			body.components.container:DropEverything()
			body.components.container:Close()
		end

		inst.vanity_body_equipped = true
	end
	
	if head ~= nil and owner ~= nil then
		print("VANITY SLOTS [SHOW ITEM]: EQUIPPED [HEAD] ITEM:", head, "OWNER:", owner)
		owner:AddTag("equipmentmodel")
		if head.components.equippable.onequiptomodelfn then
			head.components.equippable:Equip(owner)
			head.components.equippable.onequiptomodelfn(head, owner)
		end
		owner:RemoveTag("equipmentmodel")
		
		if head.components.fueled ~= nil then
			head.components.fueled:StopConsuming()
		end
		
		if head.components.perishable ~= nil then
			head.components.perishable:StopPerishing()
		end
		
		if head.components.container ~= nil then
			head.components.container:DropEverything()
			head.components.container:Close()
		end

		inst.vanity_head_equipped = true
	end
end

local function HideEquippedItem(inst, data, owner)
	local owner = inst.components.inventoryitem.owner or inst.components.inventoryitem:GetGrandOwner()
	print("VANITY SLOTS [HIDE ITEM]: FOUND OWNER:", owner)

	local hand = inst.components.container.slots[1]
	local body = inst.components.container.slots[2]
	local head = inst.components.container.slots[3]
	
	if data.eslot ~= EQUIPSLOTS.VANITY and hand == nil then
		print("VANITY SLOTS [HIDE ITEM]: UNEQUIPPED [HAND] ITEM:", hand, "OWNER:", owner)
        return
    end
	
	if data.eslot ~= EQUIPSLOTS.VANITY and body == nil then
		print("VANITY SLOTS [HIDE ITEM]: UNEQUIPPED [BODY] ITEM:", body, "OWNER:", owner)
        return
    end

	if data.eslot ~= EQUIPSLOTS.VANITY and head == nil then
		print("VANITY SLOTS [HIDE ITEM]: UNEQUIPPED [HEAD] ITEM:", head, "OWNER:", owner)
        return
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

local function OnSave(inst, data, owner)
	data.vanity_hand_equipped = inst.vanity_hand_equipped
	data.vanity_body_equipped = inst.vanity_body_equipped
	data.vanity_head_equipped = inst.vanity_head_equipped
end

local function OnLoad(inst, data, owner)
	if data and data.vanity_hand_equipped then
		
	end
	
	if data and data.vanity_body_equipped then
	
	end
	
	if data and data.vanity_head_equipped then
	
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