-- Common Dependencies.
local _G         = GLOBAL
local require    = _G.require
local EQUIPSLOTS = _G.EQUIPSLOTS
local Inventory  = require("components/inventory")

-- Workaround for opening the container when inventory shows up if it was hidden.
--[[
local _Show = Inventory.Show
function Inventory:Show(...)
	local vanitycontainer = self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
	
	if vanitycontainer ~= nil then
		vanitycontainer.components.container:Open(self.inst)
	end

    _Show(self, ...)
end

local _Open = Inventory.Open
function Inventory:Open(...)
	local vanitycontainer = self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
	
	if vanitycontainer ~= nil then
		vanitycontainer.components.container:Open(self.inst)
	end

	_Open(self, ...)
end
]]--