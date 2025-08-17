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
-- TO DO: Fix real items not re-equipping when vanity items are unequipped.
-- TO DO: Make way to equip backpacks.
-- TO DO: Make way to prevent equipped containers in vanity slot to hold items. --- DONE.
-- TO DO: Items that produce light i.e: minerhat, lantern, etc. should always be off when held.
-- TO DO: Some items don't have onequiptomodelfn, need to make one for them.

local function ShowEquippedItem(inst, data, owner)
	local owner = inst.components.inventoryitem.owner or inst.components.inventoryitem:GetGrandOwner()
	
	if owner ~= nil then
		-- print("VANITY SLOTS [SHOW ITEM]: FOUND OWNER:", owner)
		owner:AddTag("equipmentmodel")
	
		if data.item ~= nil then
			-- print("VANITY SLOTS [SHOW ITEM]: EQUIPPED [HAND] ITEM:", data.item, "OWNER:", owner)
			if data.item.components.equippable.equipslot == EQUIPSLOTS.HANDS then 
				local realitem = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
			
				if realitem ~= nil then
					realitem.components.equippable:Unequip(owner)
				
					data.item.components.equippable:Equip(owner)
					if data.item.components.equippable.onequiptomodelfn ~= nil then
						data.item.components.equippable.onequiptomodelfn(data.item, owner)
					end
				
					realitem.components.equippable:Equip(owner)
				else
					data.item.components.equippable:Equip(owner)
					if data.item.components.equippable.onequiptomodelfn ~= nil then
						data.item.components.equippable.onequiptomodelfn(data.item, owner)
					end
				end
			end
		
			-- Make them last forever for *aesthetics* A bit op? Yeah, but you're using a mod that gives you 3 extra slots anyway.
			if data.item.components.fueled ~= nil then
				data.item.components.fueled:StopConsuming()
			end
		
			if data.item.components.perishable ~= nil then
				data.item.components.perishable:StopPerishing()
			end
		
			-- You wanted to carry two krampus sacks full of items? 💀💀
			-- Nah buddy, you can't have containers with stuff inside. :steammocking:
			if data.item.components.container ~= nil then
				data.item.components.container._restrictedtag = data.item.components.container.restrictedtag
				data.item.components.container.restrictedtag = "steammocking" -- https://tenor.com/view/steammocking-gif-24857170
				
				data.item.components.container:DropEverything()
				data.item.components.container:Close()
			end

			owner:RemoveTag("equipmentmodel")
			owner.vanity_equipped = true
		end
	end
end

local function HideEquippedItem(inst, data, owner)
	local owner = inst.components.inventoryitem.owner or inst.components.inventoryitem:GetGrandOwner()
	local vanityitem = data.prev_item
	local vanityslot = data.slot
	
	if owner ~= nil then
		-- print("VANITY SLOTS [HIDE ITEM]: FOUND OWNER:", owner)
		if vanityslot ~= EQUIPSLOTS.VANITY then
			if vanityitem ~= nil and vanityitem.components.equippable ~= nil then
				vanityitem.components.equippable:Unequip(owner)
				-- print("VANITY SLOTS [HIDE ITEM]: UNEQUIPPED [HAND] ITEM:", vanityitem, "OWNER:", owner)
				
				if vanityitem.components.container ~= nil then
					if vanityitem.components.container.restrictedtag == "steammocking" then
						vanityitem.components.container.restrictedtag = nil
					else
						vanityitem.components.container.restrictedtag = vanityitem.components.container._restrictedtag
					end
				end
				
				if vanityitem.components.equippable.equipslot == EQUIPSLOTS.HANDS then
					local skin_build = vanityitem:GetSkinBuild()
					
					if skin_build ~= nil then
						owner:PushEvent("unequipskinneditem", vanityitem:GetSkinName())
					end

					owner.AnimState:Hide("ARM_carry")
					owner.AnimState:Show("ARM_normal")
					
					-- Now show the real item if it was equipped.
					local realitem = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
					
					if realitem ~= nil then
						realitem.components.equippable:Unequip(owner)
						realitem.components.equippable:Equip(owner)
					end
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

local function OnSave(inst, data, owner)
	local owner = inst.components.inventoryitem.owner or inst.components.inventoryitem:GetGrandOwner()
	
	data.vanity_equipped = owner.vanity_equipped
	print("VANITY SLOTS: SAVED EQUIPPED DATA:", data.vanity_equipped)
end

local function OnLoad(inst, data, owner)
	if data ~= nil then
		if data.vanity_equipped ~= nil then
			print("VANITY SLOTS: LOADED EQUIPPED DATA:", data.vanity_equipped)
			ShowEquippedItem(inst, data, owner)
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
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	
	inst:ListenForEvent("itemget", inst.ShowEquippedItem)
	inst:ListenForEvent("itemlose", inst.HideEquippedItem)

    return inst
end

return Prefab("vanity_slots", fn, assets)