-- This is a hidden prefab attached to the player working as a container.
-- It's basically Wilson's beard but for equippable items!
local assets =
{
	Asset("ANIM", "anim/backpack.zip"),
	Asset("ANIM", "anim/swap_krampus_sack.zip"),
	Asset("ANIM", "anim/ui_chest_3x1.zip"),
}

-- TO DO: Fix rift items making character symbols vanish.
-- TO DO: Fix vanityslots widget tooltip when opened.
-- TO DO: Fix cant move item from containers when vanity is equipped.
-- TO DO: Fix equip/use actions when vanity are equipped.
-- TO DO: Fix items that can't go in container not swapping with equipped vanity.
-- TO DO: Fix widget from appearing when dead.
-- TO DO: Make way to equip backpacks.
-- TO DO: Swap equipped item with vanity item.

local EQUIPSLOTS_VANITYSLOTS_INDEX =
{
	[EQUIPSLOTS.HANDS] = 1,
	[EQUIPSLOTS.BODY]  = 2,
	[EQUIPSLOTS.HEAD]  = 3,
}

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
				print("VANITY SLOTS: VANITY/EQUIPPED ITEM ARE THE SAME.")
				print("VANITY SLOTS: YOU SHOULDN'T BE DOING THAT.")
				if vanityitem.onequipvanity ~= nil then
					vanityitem.onequipvanity(vanityitem, inst)
				end
			else
				if vanityitem.onequipvanity ~= nil then
					vanityitem.onequipvanity(vanityitem, owner)
				end
			end
			
			ApplyVanityEffects(vanityitem)
			
			--[[
			if not vanityitem.components.onequipvanity then
				print("VANITY SLOTS: ITEM WITHOUT \"onequipvanity\" EQUIPPED.")
				print("VANITY SLOTS: LIKELY A MODDED ITEM.")
				
				if not vanityitem:HasTag("vanity_equipped") then
					vanityitem:AddTag("vanity_equipped")
				end
				
				if vanityitem.components.fueled ~= nil then
					vanityitem.components.fueled:StopConsuming()
				
					if vanityitem.components.fueled.accepting ~= nil then
						vanityitem.components.fueled.__accepting = vanityitem.components.fueled.accepting
						vanityitem.components.fueled.accepting = false
					end
				
					if vanityitem.components.fueled.no_sewing ~= nil then
						vanityitem.components.fueled.__no_sewing = vanityitem.components.fueled.no_sewing
						vanityitem.components.fueled.no_sewing = true
					end
				end
			
				if vanityitem.components.perishable ~= nil then
					vanityitem.components.perishable:StopPerishing()
				end
			end
			
			-- You wanted to carry two krampus sacks full of items? 💀💀
			-- Nah bro, you can't have containers with stuff inside. :steammocking:
			local container = vanityitem.components.container
			if container ~= nil then
				container:DropEverything(owner:GetPosition())
				container:Close(owner)
				
				container.__restrictedtag = container.restrictedtag
				container.restrictedtag = "steammocking" -- https://tenor.com/view/steammocking-gif-24857170
			end
			]]--
		end
	end
end

local function HideEquippedItem(inst, data, owner)
	local owner = inst.components.inventoryitem.owner or inst.components.inventoryitem:GetGrandOwner()
	local vanityslot = data.slot
	local vanityitem = data.prev_item
	
	local realslot = INVERTED_EQUIPSLOTS_VANITYSLOTS_INDEX[vanityslot]
	local realitem = owner.components.inventory:GetEquippedItem(realslot)
	
	if owner ~= nil then
		if vanityslot ~= nil then
			if vanityitem ~= nil and vanityitem.components.equippable ~= nil then
				vanityitem.components.equippable:Unequip(owner)
				
				RemoveVanityEffects(vanityitem)
				--[[
				if vanityitem:HasTag("vanity_equipped") then
					vanityitem:RemoveTag("vanity_equipped")
				end
				
				if vanityitem.onunequipvanity ~= nil then
					vanityitem.onunequipvanity(vanityitem, owner)
				end

				local container = vanityitem.components.container
				if container ~= nil then
					container.restrictedtag = container.__restrictedtag
				end
				
				if not vanityitem.components.onequipvanity then
				print("VANITY SLOTS: ITEM WITHOUT onequipvanity EQUIPPED.")
				print("VANITY SLOTS: LIKELY A MODDED ITEM.")
				
				if vanityitem:HasTag("vanity_equipped") then
					vanityitem:RemoveTag("vanity_equipped")
				end
				
				if vanityitem.components.fueled ~= nil then
					if vanityitem.components.equippable:IsEquipped() then
						vanityitem.components.fueled:StopConsuming()
					end
				
					if vanityitem.components.fueled.accepting ~= nil then
						vanityitem.components.fueled.accepting = vanityitem.components.fueled.__accepting
					end
				
					if vanityitem.components.fueled.no_sewing ~= nil then
						vanityitem.components.fueled.no_sewing = vanityitem.components.fueled.__no_sewing
					end
				end
			
				if vanityitem.components.perishable ~= nil then
					vanityitem.components.perishable:StopPerishing()
				end
			end
			]]--

				-- Show any real item if its equipped.
				if realitem ~= nil and realitem.components.equippable ~= nil then
					realitem.components.equippable:Unequip(owner)
					realitem.components.equippable:Equip(owner)
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
	
	inst:RemoveEventCallback("itemget", inst.ShowEquippedItem)
	inst:RemoveEventCallback("itemlose", inst.HideEquippedItem)
end

local function InitVanitySlots(inst, owner)
	local owner = inst.components.inventoryitem.owner or inst.components.inventoryitem:GetGrandOwner()
	
	if inst.components.container ~= nil then
		for slot, item in pairs(inst.components.container.slots) do
			ShowEquippedItem(inst, {item = item, slot = slot}, owner)
			print(ShowEquippedItem)
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

	inst:ListenForEvent("itemget", ShowEquippedItem)
	inst:ListenForEvent("itemlose", HideEquippedItem)
	
	-- Need this because stupid OnLoad won't run equip event.
	inst:DoTaskInTime(0, InitVanitySlots)

    return inst
end

return Prefab("vanity_slots", fn, assets)