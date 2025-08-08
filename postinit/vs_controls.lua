-- Common Dependencies.
local _G          = GLOBAL
local require     = _G.require
local TheInput    = _G.TheInput
local ThePlayer   = _G.ThePlayer
local ImageButton = require("widgets/imagebutton")
local VanitySlots = require("widgets/vanityslotswidget")

local function CalculatePosition(controls)
	local pos = 3 -- GetModConfigData("WIDGET_POSITION")
	local margin = 
	{
		x = 85, -- GetModConfigData("WIDGET_XMARGIN")
		y = 0, -- GetModConfigData("WIDGET_YMARGIN")
	}

	local x = {direction = 0, anchor = 0, margin = 0}
	local y = {direction = 0, anchor = 0, margin = 0}

	x = {direction = 1, anchor = -1, margin = -1}
	y = {direction = -2, anchor = 1, margin = 1}

	local screen_width, screen_height = _G.TheSim:GetScreenSize()
	local hudscale = controls.top_root:GetScale()
	local width = screen_width / hudscale.x
	local height = screen_height / hudscale.y

	local xpos = (x.anchor * controls.vanitySlotsBtn.size.width  / 2) + (x.direction * width  / 2) + (x.margin * margin.x)
	local ypos = (y.anchor * controls.vanitySlotsBtn.size.height / 2) + (y.direction * height / 2) + (y.margin * margin.y)
	
	print("VANITY SLOTS: Widget position set.")

	return xpos, ypos
end

local function VanitySlotsButton(controls)
	controls.vanitySlotsBtn = controls.top_root:AddChild(VanitySlots())
	
    local x, y = CalculatePosition(controls)
    controls.vanitySlotsBtn:SetPosition(x, y, 0)

    controls.owner.HUD.inst:ListenForEvent("refreshhudsize", function(hud, scale)
        if controls.vanitySlotsBtn then
            local x, y = CalculatePosition(controls)
            controls.vanitySlotsBtn:SetPosition(x, y, 0)
        end
    end)
	
	print("VANITY SLOTS: Added ClassPostConstruct")
end

AddClassPostConstruct("widgets/controls", VanitySlotsButton)