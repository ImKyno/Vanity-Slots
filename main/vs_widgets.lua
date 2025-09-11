-- Common Dependencies.
local _G          = GLOBAL
local require     = _G.require
local VanitySlots = require("widgets/vanityslotswidget")

require("vs_tuning")

-- Why are there so many copycats of EES?
local ExtraEquipSlotsMods =
{
	-- Extra Equip Slots Mods.
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
	
	-- 45 Inventory Slots Mods.
	"1986517346",
	"2166704267",
	"2568821043",
	"2801880191",
	"2802552738",
	"2906717350",
	"2965758547",
	"3075429483",
	"3355915604",
	"3548030233",
	"786556008",
}

local X_MOD_POSITION = nil
local Y_MOD_POSITION = nil

for mod, id in pairs(ExtraEquipSlotsMods) do
	if _G.KnownModIndex:IsModEnabled("workshop-"..id) then
		X_MOD_POSITION = TUNING.VANITYSLOTS_WIDGET_XPOS_MOD
		Y_MOD_POSITION = TUNING.VANITYSLOTS_WIDGET_YPOS_MOD
	end
end

local X_POSITION = X_MOD_POSITION or TUNING.VANITYSLOTS_WIDGET_XPOS
local Y_POSITION = Y_MOD_POSITION or TUNING.VANITYSLOTS_WIDGET_YPOS

AddClassPostConstruct("widgets/controls", function(self, inst)
	local owner = self.owner
	
	if owner == nil or owner:HasTag("playerghost") then
		return 
	end

	self.vanitySlotsBtn = self.inv:AddChild(VanitySlots(owner))
	self.vanitySlotsBtn:SetPosition(X_POSITION, Y_POSITION)
end)

-- Position References 
-- (self.bottom_root)
-- Bottom Right: 530, 30
-- Bottom Left: -530, 30

-- (self.inv)
-- Bottom Right: 875, 73
-- Bottom Left: -875, 73