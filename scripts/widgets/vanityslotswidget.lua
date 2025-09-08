require("util")

local Widget      = require("widgets/widget")
local Image       = require("widgets/image")
local Text        = require("widgets/text")
local ImageButton = require("widgets/imagebutton")
local TextButton  = require("widgets/textbutton")

local W_SCALE     = .33 -- .2
local W_ATLAS     = "images/crafting_menu_icons.xml"

local function RefreshVanitySlots(self)
	local inventory = self.owner.replica.inventory

	if inventory ~= nil then
		local vanitycontainer = inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
		
		if vanitycontainer ~= nil and vanitycontainer:HasTag("vanity_slots") then
			self:Show()
			return true
		end
	end

	self:Hide()
	return false
end

-- GOD I hate making widgets...
local VanitySlots = Class(Widget, function(self, owner)
	self.owner = owner
	Widget._ctor(self, "Vanity Slots")

	self.root = self:AddChild(Widget("root"))

	self.vanitySlotsBtn = self.root:AddChild(ImageButton(W_ATLAS, "filter_warable.tex", nil, nil, nil, nil, {1,1}, {0,0}))
	self.vanitySlotsBtn:SetPosition(0, 0, 0)
	self.vanitySlotsBtn:SetScale(W_SCALE, W_SCALE, W_SCALE)

	self.vanitySlotsBtn:SetOnClick(function() 
		local vanitycontainer = self.owner.replica.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)

		if vanitycontainer and not vanitycontainer.replica.container:IsOpenedBy(ThePlayer) then
			vanitycontainer.replica.container:Open(ThePlayer)
			self.VanitySlotsShown = true
			self:RefreshTooltips()
		else
			vanitycontainer.replica.container:Close(ThePlayer)
			self.VanitySlotsShown = false
			self:RefreshTooltips()
		end
	end)

	-- TO DO (MAYBE): Create setting to let player decide if container starts open or closed.
	-- HOW THE fuck do I create a client setting on a server-side mod? Oh, right, Adai did that with Accomplishments Mod.
	if TUNING.VANITYSLOTS_STARTCLOSED then
		self.inst:DoTaskInTime(0, function()
			local vanitycontainer = self.owner.replica.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)

			if vanitycontainer then
				vanitycontainer.replica.container:Close(ThePlayer)
				self.VanitySlotsShown = false
				self:RefreshTooltips()
			end
		end)
	end
	
	self.VanitySlotsShown = false
	self:RefreshTooltips()
	self:StartUpdating()
	
	self.inst:ListenForEvent("refreshinventory", function(inst)
        RefreshVanitySlots(self)
    end, self.owner)

	self.inst:ListenForEvent("playerdeactivated", function(inst)
		local inventory = self.owner.replica.inventory
		local vanitycontainer = inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
		
		if vanitycontainer ~= nil then
			vanitycontainer.replica.container:Close(ThePlayer)
			self.VanitySlotsShown = false
			self:RefreshTooltips()
		end
	end, self.owner)
	
	self.inst:ListenForEvent("playeractivated", function(inst)
		local inventory = self.owner.replica.inventory
		local vanitycontainer = inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
		
		if vanitycontainer ~= nil then
			vanitycontainer.replica.container:Open(ThePlayer)
			self.VanitySlotsShown = true
			self:RefreshTooltips()
		end
	end, self.owner)

	self.inst:ListenForEvent("equip", function(inst, data)
		if data.eslot == EQUIPSLOTS.VANITY then
			self:Show()
			
			local inventory = self.owner.replica.inventory
			local vanitycontainer = inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
			
			if vanitycontainer ~= nil then
				vanitycontainer.replica.container:Open(ThePlayer)
				self.VanitySlotsShown = true
				self:RefreshTooltips()
			end
		end
	end, self.owner)

	self.inst:ListenForEvent("unequip", function(inst, data)
		if data.eslot == EQUIPSLOTS.VANITY then
			self:Hide()
			
			local inventory = self.owner.replica.inventory
			local vanitycontainer = inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
			
			if vanitycontainer ~= nil then
				vanitycontainer.replica.container:Close(ThePlayer)
				self.VanitySlotsShown = false
				self:RefreshTooltips()
			end
		end
	end, self.owner)
	
	self.inst:ListenForEvent("vanityslots_open", function(inst)
		local inventory = self.owner.replica.inventory
		local vanitycontainer = inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
		
		if vanitycontainer ~= nil then
			self.VanitySlotsShown = true
			self:RefreshTooltips()
		end
	end, self.owner)

	-- Client only event, because when inventory is closed, we will stop
	-- getting "equip" and "unequip" events, but we can also assume that our inventory is emptied.
	self.inst:ListenForEvent("inventoryclosed", function()
		self:Hide()
		
		local inventory = self.owner.replica.inventory
		local vanitycontainer = inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
		
		if vanitycontainer ~= nil then
			vanitycontainer.replica.container:Close(ThePlayer)
			self.VanitySlotsShown = false
			self:RefreshTooltips()
		end
    end, self.owner)
end)

function VanitySlots:RefreshTooltips()
	if self.VanitySlotsShown then
		self.vanitySlotsBtn:SetTooltip(STRINGS.UI.HUD.VANITYSLOTS_CLOSE)
	else
		self.vanitySlotsBtn:SetTooltip(STRINGS.UI.HUD.VANITYSLOTS_OPEN)
	end
end

function VanitySlots:OnUpdate(dt)
	self:RefreshTooltips()
end

return VanitySlots