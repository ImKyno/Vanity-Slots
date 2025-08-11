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

local function GetEquippedItem(inst, owner)
	return (owner.components.vanityslot ~= nil and inst.components.container ~= nil) and
	{
		hand = inst.components.container.slots[1],
		body = inst.components.container.slots[2],
		head = inst.components.container.slots[3],
	} or {}
end

local function ShowEquippedItem(inst)
	local hand = inst.components.container:GetItemInSlot(1)
	local body = inst.components.container:GetItemInSlot(2)
	local head = inst.components.container:GetItemInSlot(3)
	
	if head then
		local skin_build = head:GetSkinBuild()
		local prefab = string.gsub(head.prefab, "hat", "")
		local owner = head.components.inventoryitem.owner
		
		if skin_build ~= nil then
			owner:PushEvent("equipskinneditem", head:GetSkinName())
			owner.AnimState:OverrideItemSkinSymbol("swap_hat", skin_build, "swap_hat", head.GUID, "hat_"..prefab)
			print("VANITY SLOTS: SKINNED HEAD ITEM EQUIPPED")
		else
			owner.AnimState:OverrideSymbol("swap_hat", "hat_"..prefab, "swap_hat")
			print("VANITY SLOTS: HEAD ITEM EQUIPPED")
		end
		
		owner.AnimState:ClearOverrideSymbol("headbase_hat")
		
		owner.AnimState:Show("HAT")
		owner.AnimState:Show("HAIR_HAT")
		owner.AnimState:Hide("HAIR_NOHAT")
		owner.AnimState:Hide("HAIR")
		
		owner.AnimState:Hide("HEAD")
		owner.AnimState:Show("HEAD_HAT")
		owner.AnimState:Show("HEAD_HAT_NOHELM")
		owner.AnimState:Hide("HEAD_HAT_HELM")
		
		if head:HasTag("open_top_hat") then
			owner.AnimState:Show("HAT")
			owner.AnimState:Hide("HAIR_HAT")
			owner.AnimState:Show("HAIR_NOHAT")
			owner.AnimState:Show("HAIR")

			owner.AnimState:Show("HEAD")
			owner.AnimState:Hide("HEAD_HAT")
			owner.AnimState:Hide("HEAD_HAT_NOHELM")
			owner.AnimState:Hide("HEAD_HAT_HELM")
		end
		
		if head:HasTag("fullhelm_hat") then
			owner.AnimState:Hide("HAT")
			owner.AnimState:Hide("HAIR_HAT")
			owner.AnimState:Hide("HAIR_NOHAT")
			owner.AnimState:Hide("HAIR")

			owner.AnimState:Hide("HEAD")
			owner.AnimState:Show("HEAD_HAT")
			owner.AnimState:Hide("HEAD_HAT_NOHELM")
			owner.AnimState:Show("HEAD_HAT_HELM")

			owner.AnimState:HideSymbol("face")
			owner.AnimState:HideSymbol("swap_face")
			owner.AnimState:HideSymbol("beard")
			owner.AnimState:HideSymbol("cheeks")

			owner.AnimState:UseHeadHatExchange(true)
		end
	end
end

local function HideEquippedItem(inst)
	local hand = inst.components.container:GetItemInSlot(1)
	local body = inst.components.container:GetItemInSlot(2)
	local head = inst.components.container:GetItemInSlot(3)
	
	if head then
		local skin_build = head:GetSkinBuild()
		local owner = head.components.inventoryitem.owner
		
		if skin_build ~= nil then
			owner:PushEvent("unequipskinneditem", head:GetSkinName())
        end
		
		owner.AnimState:ClearOverrideSymbol("swap_hat")
		owner.AnimState:ClearOverrideSymbol("headbase_hat")
		
		if owner.components.skinner ~= nil then
			owner.components.skinner.base_change_cb = owner.old_base_change_cb
		end
		
		owner.AnimState:Hide("HAT")
		owner.AnimState:Hide("HAIR_HAT")
		owner.AnimState:Show("HAIR_NOHAT")
		owner.AnimState:Show("HAIR")

		owner.AnimState:Show("HEAD")
		owner.AnimState:Hide("HEAD_HAT")
		owner.AnimState:Hide("HEAD_HAT_NOHELM")
		owner.AnimState:Hide("HEAD_HAT_HELM")
		
		if head:HasTag("fullhelm_hat") then
			owner.AnimState:ShowSymbol("face")
			owner.AnimState:ShowSymbol("swap_face")
			owner.AnimState:ShowSymbol("beard")
			owner.AnimState:ShowSymbol("cheeks")

			owner.AnimState:UseHeadHatExchange(false)
		end
	end
end

local function OnEquip(inst, owner)
	inst.components.container:Open(owner)
end

local function OnUnequip(inst, owner)
	inst.components.container:Close(owner)
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

	MakeHauntableLaunchAndDropFirstItem(inst)
	
	inst:ListenForEvent("itemget", function() ShowEquippedItem(inst) end)
	inst:ListenForEvent("itemlose", function() HideEquippedItem(inst) end)

    return inst
end

return Prefab("vanity_slots", fn, assets)