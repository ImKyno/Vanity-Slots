-- Common Dependencies.
local _G              = GLOBAL
local require         = _G.require
local EQUIPSLOTS      = _G.EQUIPSLOTS
local VanitySlots     = require("widgets/vanityslotswidget")
local UpvalueHacker   = require("vs_upvaluehacker")

-- Workaround for opening the container when inventory shows up if it was hidden.
AddComponentPostInit("inventory", function(self)
	local _Open = self.Open
	
	function self:Open(...)
		local vanityslots = self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
		
		if vanityslots ~= nil then
			vanityslots.components.container:Open(self.inst)
		end
		
		_Open(self, ...)
	end
end)

--[[
local OldOpen = self.Open
	function self:Open(container, doer)
		OldOpen(self, container, doer)
		local widget = container.replica.container:GetWidget()
		if widget and widget.slotbg and type(widget.slotbg) == "table" and widget.isboat then
			for i, v in ipairs(widget.slotbg) do
				if self.inv[i] then
					self.inv[i].bgimage:SetTexture(v.atlas, v.texture)
				end
			end
		end
		if widget and widget.isboat then
			self.isboat = true
			self.boatbadge:Show()
			self.inst:ListenForEvent("percentusedchange", BoatState, container)
			if GLOBAL.TheWorld.ismastersim then
				container:PushEvent("percentusedchange", { percent = container.replica.inventoryitem.classified.percentused:value() / 100 })
			else
				container.replica.inventoryitem:DeserializeUsage()
			end
		end
	end
]]--