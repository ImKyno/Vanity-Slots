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
	
	--[[
	local _FindItem = self.FindItem
	
	function self:FindItem(fn)
		local result = _FindItem(self, fn)

		if result then
			return result
		end

		local vanityslots = self:GetEquippedItem(EQUIPSLOTS.VANITY)
        
		if vanityslots and vanityslots.components.container then
			for _, item in pairs(vanityslots.components.container.slots) do
				if item and item.prefab == "lucy" and fn(item) then
					return item
				end
			end
		end

		return nil
	end
	]]--
	
	local function IsLucy(item)
		return item.prefab == "lucy"
	end
	
	local _FindItem = self.FindItem

	function self:FindItem(fn, ...)
		local result = _FindItem(self, fn, ...)

		if result ~= nil then
			return result
		end

		local vanityslots = self:GetEquippedItem(EQUIPSLOTS.VANITY)
    
		if vanityslots ~= nil and vanityslots.components.container ~= nil then
			return vanityslots.components.container:FindItem(function(item) 
				return IsLucy(item) and fn(item) 
			end)
		end
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