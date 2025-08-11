require("util")

local Widget      = require("widgets/widget")
local Image       = require("widgets/image")
local Text        = require("widgets/text")
local ImageButton = require("widgets/imagebutton")
local TextButton  = require("widgets/textbutton")

local W_SCALE     = .2
local W_ATLAS     = "images/crafting_menu_icons.xml"

local function ToggleVanitySlots()	
	local vanitycontainer = ThePlayer.replica.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
	
	if vanitycontainer and not vanitycontainer.replica.container:IsOpenedBy(ThePlayer) then
		vanitycontainer.replica.container:Open(ThePlayer)
	else
		vanitycontainer.replica.container:Close(ThePlayer)
	end
end

local function CloseVanitySlots()
	local vanitycontainer = ThePlayer.replica.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
	
	if vanitycontainer then
		vanitycontainer.replica.container:Close(ThePlayer)
	end
end

-- GOD I hate making widgets...
local VanitySlots = Class(Widget, function(self)
	Widget._ctor(self, "Vanity Slots")
	
	self.root = self:AddChild(Widget("root"))
	
	self.tasks = {}
	self.vanitySlotsBtn = self.root:AddChild(ImageButton(W_ATLAS, "filter_warable.tex", nil, nil, nil, nil, {1,1}, {0,0}))
	self.vanitySlotsBtn:SetPosition(0, 0, 0)
	self.vanitySlotsBtn:SetScale(W_SCALE, W_SCALE, W_SCALE)
	self.vanitySlotsBtn:SetOnClick(ToggleVanitySlots)
	
	-- TO DO: Create setting to let player decide if container starts open or closed.
	self.inst:DoTaskInTime(0, CloseVanitySlots)
	
	self.VanitySlotsShown = false
	self:RefreshTooltips()
	self:ShowButton()
	
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

function VanitySlots:Show()
	self._base.Show(self)
	self:RefreshTooltips()
end

function VanitySlots:ShowButton()
    self.vanitySlotsBtn:Show()
end

function VanitySlots:HideButton()
    self.vanitySlotsBtn:Hide()
end

return VanitySlots