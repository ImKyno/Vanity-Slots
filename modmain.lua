-- Common Dependencies.
local _G      = GLOBAL
local require = _G.require

-- Load everything needed.
require("vs_main")

local init_postinit =
{
	"vs_player",
	"vs_items",
	"vs_widget",
}

for _, v in pairs(init_postinit) do
	modimport("postinit/"..v)
end

PrefabFiles =
{
	"vanity_slots",
}