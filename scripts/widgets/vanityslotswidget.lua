require("util")

local Widget      = require("widgets/widget")
local Image       = require("widgets/image")
local ImageButton = require("widgets/imagebutton")
local Text        = require("widgets/text")

local function ToggleVanitySlots()
	local vanitycontainer = ThePlayer.replica.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
	
	if vanitycontainer then
		vanitycontainer.replica.container:Open(ThePlayer)
		TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
		print("VANITY SLOTS: Widget opened.")
	end
end

-- GOD I hate making widgets...
local VanitySlotsWidget = Class(Widget, function(self)
	Widget._ctor(self, "VanitySlots")
	self:UpdateWhilePaused(false)
	
	self.tasks = {}
	self.vanitySlotsBtn = self:AddChild(ImageButton("images/crafting_menu_icons.xml", "warable.tex", nil, nil, nil, nil, {1,1}, {0,0}))
	self.vanitySlotsBtn:SetScale(2, 2, 2)
	self.vanitySlotsBtn:SetOnClick(ToggleVanitySlots)
	
	local width, height = self.vanitySlotsBtn:GetSize()
	self.size = 
	{
		width = width,
		height = height,
	}
	
	print("VANITY SLOTS: Widget created.")
	
	-----------------------------------------------------------------------------------------------------------------
	-- Shows x/y Position on the screen for lookup.
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
	
	self:RefreshTooltips()
end)

function VanitySlotsWidget:RefreshTooltips()
    self.vanitySlotsBtn:SetTooltip("View Cosmetic Slots")
end

return VanitySlotsWidget