-- This is a hidden prefab attached to the player working as a container.
-- It's basically Wilson's beard but for clothing items!
local assets =
{
	Asset("ANIM", "anim/backpack.zip"),
	Asset("ANIM", "anim/swap_krampus_sack.zip"),
	Asset("ANIM", "anim/ui_chest_3x1.zip"),

	Asset("IMAGE", "images/vanity_slots.tex"),
	Asset("ATLAS", "images/vanity_slots.xml"),
}

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
	inst.components.container.skipopensnd = true
	inst.components.container.skipclosesnd = true
	inst.components.container.stay_open_on_hide = true

	MakeHauntableLaunchAndDropFirstItem(inst)

    return inst
end

return Prefab("vanity_slots", fn, assets)