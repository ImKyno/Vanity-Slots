require("util")

local Widget      = require("widgets/widget")
local Image       = require("widgets/image")
local Text        = require("widgets/text")
local ImageButton = require("widgets/imagebutton")
local TextButton  = require("widgets/textbutton")

local W_SCALE     = .33 -- .2
local W_ATLAS     = "images/crafting_menu_icons.xml"

local function TryVanitySlots(self)
	local inventory = self.owner.replica.inventory
	
	if inventory ~= nil then
		local vanityslots = inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
		
		if vanityslots ~= nil and vanityslots:HasTag("vanity_slots") then
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
	
	self.tasks = {}
	
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
	
	-- TO DO: Create setting to let player decide if container starts open or closed.
	if not TUNING.VANITYSLOTS_STARTOPEN then
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
	
	self.inst:ListenForEvent("refreshinventory", function(inst)
        TryVanitySlots(self)
    end, self.owner)

    self.inst:ListenForEvent("finishseamlessplayerswap", function()
		self:Show()
    end, self.owner)
	
	self.inst:ListenForEvent("equip", function(inst, data)
		if data.item ~= nil and data.item:HasTag("vanity_slots") then
			self:Show()
		end
	end, self.owner)
	
	self.inst:ListenForEvent("unequip", function(inst, data)
		if data.eslot == EQUIPSLOTS.VANITY then
			self:Hide()
		end
	end, self.owner)
	
	-- Client only event, because when inventory is closed, we will stop
	-- getting "equip" and "unequip" events, but we can also assume that our inventory is emptied.
	self.inst:ListenForEvent("inventoryclosed", function()
		self:Hide()
    end, self.owner)
	
	-----------------------------------------------------------------------------------------------------------------
	-- Shows x/y position on the screen for easy lookup.
	--[[
	self.animationUp = self.root:AddChild(Text(NEWFONT_OUTLINE, 30, "Y: ", {unpack(UICOLOURS.RED)}))
	self.animationUp:SetPosition(-520, -350)
  
	self.tasks[#self.tasks + 1] = self.inst:DoPeriodicTask(.1, function()
		local pos = self.animationUp:GetPosition()
		self.animationUp:SetPosition(pos.x, pos.y > 350 and -350 or pos.y + 5)
		self.animationUp:SetString("Y: " .. pos.y)
	end)

	self.animationRight = self.root:AddChild(Text(NEWFONT_OUTLINE, 30, "X: ", {unpack(UICOLOURS.RED)}))
	self.animationRight:SetPosition(-600, -290)
 
	self.tasks[#self.tasks + 1] = self.inst:DoPeriodicTask(.1, function()
		local pos = self.animationRight:GetPosition()
		self.animationRight:SetPosition(pos.x > 600 and -600 or pos.x + 5, pos.y)
		self.animationRight:SetString("X: " .. pos.x)
	end)
	]]--
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