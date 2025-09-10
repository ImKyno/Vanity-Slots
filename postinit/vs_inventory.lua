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
	local widget = container.replica.container:GetWidget()
	if widget ~= nil and widget.type == "vanity"
	if widget and widget.slotbg and type(widget.slotbg) == "table" then
		for i, v in ipairs(widget.slotbg) do
			if self.inv[i] then
				self.inv[i].bgimage:SetTexture(v.atlas, v.texture)
			end
		end
	end
]]--