local function OnRespawn(inst)
    inst.components.vanityslots:Reset()
end

local VanitySlots = Class(function(self, inst)
	self.inst = inst

	inst:AddTag("vanityslotsowner")

	self.callbacks = {}
	self.bits = 3
	self.pause = nil
	self.onreset = nil
	
	inst:ListenForEvent("ms_respawnedfromghost", OnRespawn)
end)

function VanitySlots:OnRemoveFromEntity()
	self.inst:RemoveTag("vanityslotsowner")
	
	self.inst:RemoveEventCallback("ms_respawnedfromghost", OnRespawn)
end

function VanitySlots:Reset()
	self.bits = 3
	
	if self.onreset ~= nil then
		self.onreset(self.inst)
	end
	
	self:UpdateVanitySlotsInventory()
end

function VanitySlots:OnSave()
	return
	{
		bits = self.bits,
	}
end

function VanitySlots:OnLoad(data)
	if data.bits ~= nil then
		self.bits = data.bits
	end
end

function VanitySlots:LoadPostPass(newents, data)
	self:UpdateVanitySlotsInventory()
end

function VanitySlots:UpdateVanitySlotsInventory()
	local vanityslots = nil
	
	if self.bits >= 3 then
		vanityslots = "vanity_slots"
	end
	
	local vanitycontainer = self.inst.components.inventory and self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)

	if vanityslots and not self.inst:HasTag("playerghost") then
		if not vanitycontainer then
			local newcontainer = SpawnPrefab(vanityslots)
			self.inst.components.inventory:Equip(newcontainer)
		else
			if vanitycontainer then
				vanitycontainer.components.container:DropEverything()
				vanitycontainer:Remove()
			end
		end
	end
	
	--[[
	if vanityslots then
		if not vanitycontainer then
			-- Has slots but no container. Give one container.
			local newcontainer = SpawnPrefab(vanityslots)
			self.inst.components.inventory:Equip(newcontainer)
		elseif not vanitycontainer:HasTag(vanityslots) then 
			-- Has slots and container but wrong data. Give appropriate data and transfer items.
			local containeritems = vanitycontainer.components.container:RemoveAllItems()
			vanitycontainer.components.container:Close(self.inst)
			vanitycontainer:Remove()
		
			local newcontainer = SpawnPrefab(vanityslots)
			self.isnt.components.inventory:Equip(newcontainer)
		
			for slot, item in ipairs(containeritems) do
				newcontainer.components.container:GiveItem(item, slot, nil, true)
			end
		end
	else
		if vanitycontainer then
			-- No slots but has container. Remove container.
			vanitycontainer.components.container:DropEverything()
			vanitycontainer:Remove()
		end
	end
	]]--
end

return VanitySlots