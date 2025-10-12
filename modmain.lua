-- Common Dependencies.
local _G      = GLOBAL
local require = _G.require

-- Load everything needed.
require("vs_main")

-- Mod Strings Localization.
local localization = GetModConfigData("LANGUAGE", true)
if localization then
	require("strings/vs_strings_"..localization)
end

local init_main =
{
	"vs_actions",
	"vs_extraequipslots",
	"vs_stategraphs",
	"vs_widgets",
}

local init_postinit =
{
	"vs_inventory",
	"vs_inventoryitem",
	"vs_sanity",

	"vs_items",
	"vs_items_body",
	"vs_items_hands",
	"vs_items_head",
	"vs_items_symbols",

	"vs_player",
	"vs_playerhud",
}

local init_icons =
{
	"vanity_hands_item",
	"vanity_body_item",
	"vanity_head_item",
}

for icon, name in pairs(init_icons) do
	RegisterInventoryItemAtlas("images/inventoryimages/vanity_clothing.xml", name..".tex")
end

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

_G.VANITYSLOTS_VANITYCLOTHING = GetModConfigData("CLOTHING")

if _G.VANITYSLOTS_VANITYCLOTHING then
	modimport("main/vs_recipes")
	table.insert(PrefabFiles, "vanity_clothing")
end