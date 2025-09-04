-- Common Dependencies.
local _G          = GLOBAL
local require     = _G.require
local VanitySlots = require("widgets/vanityslotswidget")

-- Why are there so many copycats of EES?
local ExtraEquipSlotsMods =
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
	"3548030233",
	"375850593",
}

-- TO DO (MAYBE): Make widget position compatible with EES mods.
AddClassPostConstruct("widgets/controls", function(self, inst)
	local owner = self.owner
	
	if owner == nil or owner:HasTag("playerghost") then
		return 
	end

	self.vanitySlotsBtn = self.inv:AddChild(VanitySlots(owner))
	self.vanitySlotsBtn:SetPosition(875, 73)
end)

-- Position References 
-- (self.bottom_root)
-- Bottom Right: 530, 30
-- Bottom Left: -530, 30

-- (self.inv)
-- Bottom Right: 875, 73
-- Bottom Left: -875, 73