-- Common Dependencies.
local _G      = GLOBAL
local require = _G.require

-- Load everything needed.
require("vs_main")

local init_main =
{
	"vs_actions",
	"vs_stategraphs",
	"vs_widget",
}

local init_postinit =
{
	"vs_items",
	"vs_items_hands",
	"vs_items_body",
	"vs_items_head",

	"vs_player",
	"vs_inventory",
	"vs_inventoryitem",
}

for _, v in pairs(init_main) do
	modimport("main/"..v)
end

for _, v in pairs(init_postinit) do
	modimport("postinit/"..v)
end

PrefabFiles =
{
	"vanity_slots",
}