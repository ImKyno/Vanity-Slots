-- This is a hidden prefab attached to the player working as a container.
-- It's basically Wilson's beard but for clothing items!
local assets =
{
	Asset("ANIM", "anim/backpack.zip"),
	Asset("ANIM", "anim/swap_krampus_sack.zip"),
	Asset("ANIM", "anim/ui_chest_3x1.zip"),
	
	-- Unused.
	Asset("ANIM", "anim/ui_vanity_1x2.zip"),
	Asset("ANIM", "anim/ui_vanity_1x3.zip"),

	Asset("IMAGE", "images/vanity_slots.tex"),
	Asset("ATLAS", "images/vanity_slots.xml"),
}

local function ShowEquippedItem(inst, data, owner)
	local owner = inst.components.inventoryitem.owner or inst.components.inventoryitem:GetGrandOwner()
	print("VANITY SLOTS [SHOW ITEM]: FOUND OWNER:", owner)

	local hand = inst.components.container:GetItemInSlot(1)
	local body = inst.components.container:GetItemInSlot(2)
	local head = inst.components.container:GetItemInSlot(3)
	
	if head ~= nil and owner ~= nil then
		print("VANITY SLOTS [SHOW ITEM]: EQUIPPED ITEM:", head, "OWNER:", owner)
		head.components.equippable:Equip(owner)
		
		owner.vanity_head_equipped = true
		
		-- Make them last forever for *aesthetics* A bit op? Yeah, but you're using a mod that gives you 3 extra slots anyway.
		if head.components.fueled ~= nil then
			head.components.fueled:StopConsuming()
		end
		
		if head.components.perishable ~= nil then
			head.components.perishable:StopPerishing()
		end
	end
end

local function HideEquippedItem(inst, data, owner)
	local owner = inst.components.inventoryitem.owner or inst.components.inventoryitem:GetGrandOwner()
	print("VANITY SLOTS [HIDE ITEM]: FOUND OWNER:", owner)

	local hand = inst.components.container.slots[1]
	local body = inst.components.container.slots[2]
	local head = inst.components.container.slots[3]

	if data.eslot ~= EQUIPSLOTS.VANITY and head == nil then
		print("VANITY SLOTS [HIDE ITEM]: UNEQUIPPED ITEM:", head, "OWNER:", owner)
        return -- asdfghjkln
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

local function OnSave(inst, data)
	
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
	-- inst.components.container.skipopensnd = true
	-- inst.components.container.skipclosesnd = true
	inst.components.container.stay_open_on_hide = true
	
	inst.ShowEquippedItem = ShowEquippedItem
	inst.HideEquippedItem = HideEquippedItem
	
	inst:ListenForEvent("itemget", inst.ShowEquippedItem)
	inst:ListenForEvent("itemlose", inst.HideEquippedItem)

    return inst
end

return Prefab("vanity_slots", fn, assets)