local assets =
{
	-- Asset("ANIM", "anim/vanity_clothing.zip"),
	
	Asset("IMAGE", "images/inventoryimages/vanity_clothing.tex"),
	Asset("ATLAS", "images/inventoryimages/vanity_clothing.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/vanity_clothing.xml", 256),
}

local function OnEquip(inst, owner)
	if inst:HasTag("vanity_hand") then
		owner.AnimState:OverrideSymbol("swap_object", "swap_vanity_hand", "swap_object")
		owner.AnimState:Hide("ARM_carry")
		owner.AnimState:Show("ARM_normal")
		
	elseif inst:HasTag("vanity_body") then
		owner.AnimState:OverrideSymbol("swap_body", "swap_vanity_body", "swap_body")
		
	elseif inst:HasTag("vanity_head") then
		owner.AnimState:OverrideSymbol("swap_hat", "swap_vanity_hands", "swap_hat")
		owner.AnimState:Show("HAT")
		owner.AnimState:Hide("HAIR_HAT")
		owner.AnimState:Show("HAIR_NOHAT")
		owner.AnimState:Show("HAIR")

		owner.AnimState:Show("HEAD")
		owner.AnimState:Hide("HEAD_HAT")
		owner.AnimState:Hide("HEAD_HAT_NOHELM")
		owner.AnimState:Hide("HEAD_HAT_HELM")
	end
end

local function OnUnequip(inst, owner)
	if inst:HasTag("vanity_hand") then
		owner.AnimState:ClearOverrideSymbol("swap_object")
	elseif inst:HasTag("vanity_body") then
		owner.AnimState:ClearOverrideSymbol("swap_body")
	elseif inst:HasTag("vanity_head") then
		owner.AnimState:ClearOverrideSymbol("swap_head")
	end
end

local function OnDropped(inst)
	if inst:IsValid() then
		inst:Remove()
	end
end

local function OnEntityRemove(inst, owner)
	inst:RemoveEventCallback("ondropped", OnDropped)
end

local function commonfn(anim, tag, symbolname1, symbolname2, equipslot)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	-- inst.AnimState:SetBank("vanity_clothing")
	-- inst.AnimState:SetBuild("vanity_clothing")
	-- inst.AnimState:PlayAnimation(anim)

    inst:AddTag("vanity_item")
	inst:AddTag(tag)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst.components.inspectable:SetNameOverride("vanity_clothing")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/vanity_clothing.xml"
	inst.components.inventoryitem.imagename = inst.prefab

	inst:AddComponent("equippable")
	inst.components.equippable.equipslot = equipslot
	inst.components.equippable.restrictedtag = "steammocking" -- Just so you can't equip them.
	inst.components.equippable:SetOnEquip(OnEquip)
	inst.components.equippable:SetOnUnequip(OnUnequip)
	
	inst:ListenForEvent("ondropped", OnDropped) -- Remove when dropped.
	inst:ListenForEvent("onremove", OnEntityRemove)

	return inst
end

local function handsfn()
	return commonfn("hands", "vanity_hand", "vanity_hands_item", "vanity_hands_item", EQUIPSLOTS.HANDS)
end

local function bodyfn()
	return commonfn("body", "vanity_body", "vanity_body_item", "vanity_body_item", EQUIPSLOTS.BODY)
end

local function headfn()
	return commonfn("head", "vanity_head", "vanity_head_item", "vanity_head_item", EQUIPSLOTS.HEAD)
end

return Prefab("vanity_hands_item", handsfn, assets),
Prefab("vanity_body_item", bodyfn, assets),
Prefab("vanity_head_item", headfn, assets)