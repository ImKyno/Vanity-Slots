local function OnRespawn(inst)
    inst.components.vanityslots:UpdateVanitySlotsInventory()
end

local VanitySlots = Class(function(self, inst)
    self.inst = inst
	self.maxslots = TUNING.VANITY_SLOTS_MAXSLOTS -- Unused.

    self.inst:AddTag("vanityslotsowner")
end)

function VanitySlots:OnRemoveFromEntity()
    self.inst:RemoveTag("vanityslotsowner")
	
	self.inst:RemoveEventCallback("ms_respawnedfromghost", OnRespawn)
end

function VanitySlots:LoadPostPass(newents, data)
    self:UpdateVanitySlotsInventory()
end

function VanitySlots:UpdateVanitySlotsInventory()
    local vanitycontainer = self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)

    if vanitycontainer == nil and not self.inst:HasTag("playerghost") then
		local newvanitycontainer = SpawnPrefab("vanity_slots")
        self.inst.components.inventory:Equip(newvanitycontainer)
    end
end

return VanitySlots