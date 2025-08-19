-- Common Dependencies.
local _G            = GLOBAL
local require       = _G.require
local ACTIONS       = _G.ACTIONS
local ActionHandler = _G.ActionHandler

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.EQUIPVANITY, function(inst, action)
	return "doshortaction"
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.EQUIPVANITY, function(inst, action)
	return "doshortaction"
end))