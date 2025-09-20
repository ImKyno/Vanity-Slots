-- Common Dependencies.
local _G           = GLOBAL
local require      = _G.require
local EQUIPSLOTS   = _G.EQUIPSLOTS

local EQUIPSLOTS_VANITYSLOTS_INDEX = TUNING.EQUIPSLOTS_VANITYSLOTS_INDEX
local INVERTED_EQUIPSLOTS_VANITYSLOTS_INDEX = table.invert(EQUIPSLOTS_VANITYSLOTS_INDEX)

local function AddVanitySlots(inst)
	local function RemoveVanitySlots(inst)
		local vanityslots = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
		
		if vanityslots then
			vanityslots.components.container:DropEverything()
			vanityslots:Remove()
		end
	end

	local function CheckVanitySlots(inst, owner)
		local vanityslots = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
		
		if vanityslots == nil then
			inst.components.vanityslots:UpdateVanitySlotsInventory()
		end
	end
	
	local function SwapToVanityItem(inst, data)
		local vanityslots = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
		local vanityitem = vanityslots ~= nil and vanityslots.components.container:GetItemInSlot(EQUIPSLOTS_VANITYSLOTS_INDEX[data.eslot]) or nil
		local realitem = data.item
		
		if vanityitem ~= nil and vanityitem.components.equippable ~= nil and not realitem:HasTag("heavy") then
			if vanityitem:HasTag("vanity_equip_onload") then -- Unequipping it causes assert fail.
				vanityitem.components.equippable:Equip(inst)
			else
				vanityitem.components.equippable:Unequip(inst)
				vanityitem.components.equippable:Equip(inst)
			end
			
			if realitem and realitem.prefab == vanityitem.prefab then 
				-- print("VANITY SLOTS: EQUIPPED/VANITY ITEM ARE THE SAME.")
				-- print("VANITY SLOTS: YOU SHOULDN'T BE DOING THAT.")
				if vanityitem.onequipvanity ~= nil then
					vanityitem.onequipvanity(vanityitem, vanityslots)
				end
			else
				if vanityitem.onequipvanity ~= nil then
					vanityitem.onequipvanity(vanityitem, inst)
				end
			end
			
			-- "Hide" animated items for client, fx still exists in the server.
			if realitem ~= nil then
				_G.RemoveRealItemsFX(realitem, inst)
				_G.ApplyOverlayEffects(vanityitem, realitem, inst)
			
				if realitem ~= nil and realitem.components.container ~= nil then
					realitem.components.container:Open(inst)
				end
			end
			
			_G.ApplyVanityEffects(vanityitem, inst)
			_G.ApplyContainerEffects(vanityitem, realitem, inst)
		end
	end
	
	local function SwapToRealItem(inst, data)
		local vanityslots = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
		local vanityitem = vanityslots ~= nil and vanityslots.components.container:GetItemInSlot(EQUIPSLOTS_VANITYSLOTS_INDEX[data.eslot]) or nil

		if vanityitem ~= nil and vanityitem.components.equippable ~= nil then	
			vanityitem.components.equippable:Unequip(inst)
			vanityitem.components.equippable:Equip(inst)
			
			if vanityitem.onequipvanity ~= nil then
				vanityitem.onequipvanity(vanityitem, inst)
			end
			
			_G.RemoveOverlayEffects(vanityitem, realitem, inst)
			_G.ApplyContainerEffects(vanityitem, realitem, inst)
		end
	end
	
	local function OnSeamlessPlayerSwap(inst)
		local vanityslots = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
		
		-- Re-equip vanity items on transform.
		if vanityslots ~= nil then
			vanityslots:DoTaskInTime(0, vanityslots.RefreshEquippedItem)
		end
	end

	local function OnSanityDelta(inst)
		-- This is for refreshing vanity items when alterguardianhat becomes active/inactive.
		print("VANITY SLOTS: CROWNSANITYDELTA")
		local equippedhat = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
		local vanityslots = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
		local vanityitem = vanityslots ~= nil and vanityslots.components.container:GetItemInSlot(3) or nil

		if equippedhat ~= nil and equippedhat.prefab == "alterguardianhat" then
			if vanityslots ~= nil and vanityitem ~= nil then
				inst:DoTaskInTime(0.25, function()
					if vanityitem:HasTag("vanity_equip_onload") then
						-- Empty because we standby.
					else
						vanityitem.components.equippable:Unequip(inst)
						vanityitem.components.equippable:Equip(inst)
					end
			
					if equippedhat and equippedhat.prefab == vanityitem.prefab then
						if vanityitem.onequipvanity ~= nil then
							vanityitem.onequipvanity(vanityitem, vanityslots)
						end
					else
						if vanityitem.onequipvanity ~= nil then
							vanityitem.onequipvanity(vanityitem, inst)
						end
					end

					_G.ApplyVanityEffects(vanityitem, inst)
					_G.ApplyContainerEffects(vanityitem, equippedhat, inst)
				end)
			end
		end
	end

	inst:AddTag("vanityslotsowner")

	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("vanityslots")
	
	inst.RemoveVanitySlots = RemoveVanitySlots
	inst:ListenForEvent("death", RemoveVanitySlots)
	
	inst.CheckVanitySlots = CheckVanitySlots
	inst:DoTaskInTime(0, CheckVanitySlots)
	
	inst:ListenForEvent("equip", SwapToVanityItem)
	inst:ListenForEvent("unequip", SwapToRealItem)
	inst:ListenForEvent("seamlessplayerswap", OnSeamlessPlayerSwap)
	inst:ListenForEvent("crownsanitydelta", OnSanityDelta)
end

AddPlayerPostInit(AddVanitySlots)