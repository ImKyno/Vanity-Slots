-- Common Dependencies.
local _G          = GLOBAL
local require     = _G.require
local TheSim      = _G.TheSim
local VanitySlots = require("widgets/vanityslotswidget")

AddClassPostConstruct("widgets/controls", function(self)
	self.vanitySlotsBtn = self.bottom_root:AddChild(VanitySlots())
	self.vanitySlotsBtn:SetPosition(530, 30)
end)

-- Position References
-- Bottom Right: 530, 30
-- Bottom Left: -530, 30