-- Common Dependencies.
local _G          = GLOBAL
local next        = _G.next
local require     = _G.require
local TheInput    = _G.TheInput
local EQUIPSLOTS  = _G.EQUIPSLOTS
local VanitySlots = require("widgets/vanityslotswidget")

require("vs_tuning")

local X_MOD_POSITION = nil
local Y_MOD_POSITION = nil

--[[
for mod, id in pairs(TUNING.VANITY_EXTRA_EQUIP_SLOTS_MODS) do
	if _G.KnownModIndex:IsModEnabled("workshop-"..id) then
		X_MOD_POSITION = TUNING.VANITYSLOTS_WIDGET_XPOS_MOD
		Y_MOD_POSITION = TUNING.VANITYSLOTS_WIDGET_YPOS_MOD
	end
end
]]--

-- TO DO: Improve widget position. I should make it multiply by inventory size and not EQUIPSLOTS.
if _G.GetTableSize(EQUIPSLOTS) > 6 then
	X_MOD_POSITION = TUNING.VANITYSLOTS_WIDGET_XPOS_MOD
	Y_MOD_POSITION = TUNING.VANITYSLOTS_WIDGET_YPOS_MOD
end

if _G.KnownModIndex:IsModEnabled("workshop-3554455753") then
	X_MOD_POSITION = TUNING.VANITYSLOTS_WIDGET_XPOS + 30
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

_G.VANITYSLOTS_KEYBIND = GetModConfigData("KEYBIND", true) 

if _G.VANITYSLOTS_KEYBIND ~= false then
	_G.VANITYSLOTS_KEYBIND = _G.json.decode(_G.VANITYSLOTS_KEYBIND)
end

-- KEYBIND can be false.
if type(_G.VANITYSLOTS_KEYBIND) ~= "table" then
    return
end

local KEY_WARNING = nil

if next(TheInput.onkeyup:GetHandlersForEvent(_G.VANITYSLOTS_KEYBIND.id)) ~= nil or 
	next(TheInput.onkeydown:GetHandlersForEvent(_G.VANITYSLOTS_KEYBIND.id)) ~= nil then
	KEY_WARNING = string.format("VANITY SLOTS: The game or other mod is already using the [%s] keybind to perform something.", 
	_G.VANITYSLOTS_KEYBIND.name or "Keybind not found.")
end

TheInput:AddKeyUpHandler(_G.VANITYSLOTS_KEYBIND.id, function()
    if _G.ThePlayer ~= nil and _G.ThePlayer.HUD ~= nil and not _G.ThePlayer.HUD:HasInputFocus() then
        if KEY_WARNING ~= nil then 
			print(KEY_WARNING) 
		end
		
		local vanityslotswidget = _G.ThePlayer.HUD.controls.vanitySlotsBtn

        if vanityslotswidget ~= nil then
			local vanitycontainer = vanityslotswidget ~= nil and vanityslotswidget.owner.replica.inventory:GetEquippedItem(EQUIPSLOTS.VANITY)
			
			if vanitycontainer ~= nil then
				if not vanitycontainer.replica.container:IsOpenedBy(_G.ThePlayer) then
					vanitycontainer.replica.container:Open(_G.ThePlayer)
					vanityslotswidget.VanitySlotsShown = true
					vanityslotswidget:RefreshTooltips()
				else
					vanitycontainer.replica.container:Close(_G.ThePlayer)
					vanityslotswidget.VanitySlotsShown = false
					vanityslotswidget:RefreshTooltips()
				end
			end
		end
    end
end)

-- Position References 
-- (self.bottom_root)
-- Bottom Right: 530, 30
-- Bottom Left: -530, 30

-- (self.inv)
-- Bottom Right: 875, 73
-- Bottom Left: -875, 73