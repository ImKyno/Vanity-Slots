-- Common Dependencies.
local _G          = GLOBAL
local require     = _G.require
local TheSim      = _G.TheSim
local VanitySlots = require("widgets/vanityslotswidget")

local ExtraEquipSlotMods =
{
	"1818688368",
	"2032685784",
	"2075943614",
	"2754944282",
	"2798599672",
	"2946486855",
	"2950481491",
	"3026138806",
	"3045668614",
	"3104797181",
	"3134194859",
	"3363970980",
	"3496081977",
	"375850593",
}

AddClassPostConstruct("widgets/controls", function(self)
	self.vanitySlotsBtn = self.bottom_root:AddChild(VanitySlots())
	self.vanitySlotsBtn:SetPosition(530, 30)
end)

-- Position References
-- Bottom Right: 530, 30
-- Bottom Left: -530, 30