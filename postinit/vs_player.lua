-- Common Dependencies.
local _G            = GLOBAL
local require       = _G.require
local SpawnPrefab   = _G.SpawnPrefab
local ACTIONS       = _G.ACTIONS
local EQUIPSLOTS    = _G.EQUIPSLOTS
local UpvalueHacker = require("vs_upvaluehacker")

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
	
	local function RefreshCrownItem(inst, vanityslots, vanityitem, realitem)
		if vanityitem:HasTag("vanity_equip_onload") then
			-- Empty because we standby.
		else
			-- vanityitem.components.equippable:Unequip(inst)
			vanityitem.components.equippable:Equip(inst)
		end
			
		if realitem and realitem.prefab == vanityitem.prefab then
			if vanityitem.onequipvanity ~= nil then
				vanityitem.onequipvanity(vanityitem, vanityslots)
			end
		else
			if vanityitem.onequipvanity ~= nil then
				vanityitem.onequipvanity(vanityitem, inst)
			end
		end

		_G.ApplyVanityEffects(vanityitem, inst)
		_G.ApplyContainerEffects(vanityitem, realitem, inst)
	end

	local function OnCrownSanityDelta(inst)
		-- This is for refreshing vanity items when alterguardianhat becomes active/inactive.
		local realitem = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
		local vanityslots = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
		local vanityitem = vanityslots ~= nil and vanityslots.components.container:GetItemInSlot(3) or nil
		
		local sanity = inst.components.sanity ~= nil and inst.components.sanity:GetPercentWithPenalty() or 0

		if realitem ~= nil and realitem.prefab == "alterguardianhat" then
			if vanityslots ~= nil and vanityitem ~= nil then
				if sanity > TUNING.SANITY_BECOME_ENLIGHTENED_THRESH then
					inst:DoTaskInTime(0, function()
						RefreshCrownItem(inst, vanityslots, vanityitem, realitem)
					end)
				else
					inst:DoTaskInTime(0.2699, function()
						RefreshCrownItem(inst, vanityslots, vanityitem, realitem)
					end)
				end
			end
		elseif realitem ~= nil and realitem:HasTag("vanity_affects_crown") then
			if vanityslots ~= nil and vanityitem ~= nil then
				if sanity > TUNING.SANITY_BECOME_ENLIGHTENED_THRESH then
					inst:DoTaskInTime(0, function()
						RefreshCrownItem(inst, vanityslots, vanityitem, realitem)
					end)
				else
					inst:DoTaskInTime(0.2699, function()
						RefreshCrownItem(inst, vanityslots, vanityitem, realitem)
					end)
				end
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
	inst:ListenForEvent("crownsanitydelta", OnCrownSanityDelta)
end

AddPlayerPostInit(AddVanitySlots)

local function KeepLucyAsVanityItem(inst)
	local function IsLucy(item)
		return item.prefab == "lucy"
	end
	
	local _onworked = UpvalueHacker.GetUpvalue(_G.Prefabs.woodie.fn, "master_postinit", "onpreload", "onbecamebeaver", "SetWereWorker", "onworked")
	
	local function onworked(inst, data)
		if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY).components.container:FindItem(IsLucy) ~= nil then
			return
		end
		
		return _onworked(inst, data)
	end
	
	UpvalueHacker.SetUpvalue(_G.Prefabs.woodie.fn, onworked, "master_postinit", "onpreload", "onbecamebeaver", "SetWereWorker", "onworked")
end

AddPrefabPostInit("woodie", KeepLucyAsVanityItem)