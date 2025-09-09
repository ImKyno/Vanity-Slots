-- Common Dependencies.
local _G            = GLOBAL
local require       = _G.require
local EQUIPSLOTS    = _G.EQUIPSLOTS
local UpvalueHacker = require("vs_upvaluehacker")

require("vs_tuning")

-- Symbol Names for some items because stupid Klei has inconsistences.
-- Yes must include "swap_" because some items don't have it? 💀💀
TUNING.VANITY_SYMBOLNAMES =
{
	moonglassaxe = 
	{
		symbol1 = "swap_glassaxe",
		symbol2 = "swap_glassaxe",
	},
	
	lucy = 
	{
		symbol1 = "swap_lucy_axe",
		symbol2 = "swap_lucy_axe",
	},
	
	pickaxe_lunarplant =
	{
		symbol1 = "pickaxe_lunarplant",
		symbol2 = "swap_pickaxe_lunarplant",
	},
	
	shovel_lunarplant =
	{
		symbol1 = "shovel_lunarplant",
		symbol2 = "swap_shovel_lunarplant",
	},
	
	fence_rotator =
	{
		symbol1 = "fence_rotator",
		symbol2 = "swap_fence_rotator",
	},
	
	thulecitebugnet =
	{
		symbol1 = "thulecitebugnet",
		symbol2 = "swap_object",
	},
	
	gestalt_cage =
	{
		symbol1 = "gestalt_cage",
		symbol2 = "swap_object",
	},
	
	farm_hoe =
	{
		symbol1 = "quagmire_hoe",
		symbol2 = "swap_quagmire_hoe",
	},
	
	golden_farm_hoe =
	{
		symbol1 = "swap_goldenhoe",
		symbol2 = "swap_goldenhoe",
	},
	
	oceanfishingrod =
	{
		symbol1 = "swap_fishingrod_ocean",
		symbol2 = "swap_fishingrod_ocean",
	},
	
	wortox_nabbag =
	{
		symbol1 = "swap_wortox_nabbag",
		symbol2 = "swap_wortox_nabbag_empty",
	},
	
	spear_wathgrithr_lightning =
	{
		symbol1 = "spear_wathgrithr_lightning",
		symbol2 = "swap_spear_wathgrithr_lightning",
	},
	
	spear_wathgrithr_lightning_charged =
	{
		symbol1 = "spear_wathgrithr_lightning",
		symbol2 = "swap_spear_wathgrithr_lightning",
	},
	
	chum =
	{
		symbol1 = "swap_chum_pouch",
		symbol2 = "swap_chum_pouch",
	},
	
	bomb_lunarplant =
	{
		symbol1 = "bomb_lunarplant",
		symbol2 = "swap_bomb_lunarplant",
	},
	
	snowball_item =
	{
		symbol1 = "snowball",
		symbol2 = "swap_object",
	},
	
	waterplant_bomb =
	{
		symbol1 = "swap_barnacle_burr",
		symbol2 = "swap_barnacle_burr",
	},
	
	firepen =
	{
		symbol1 = "firepen",
		symbol2 = "swap_firepen",
	},
	
	pocketwatch_weapon =
	{
		symbol1 = "pocketwatch_weapon",
		symbol2 = "swap_object",
	},
	
	firestaff =
	{
		symbol1 = "swap_staffs",
		symbol2 = "swap_redstaff",
	},
	
	icestaff =
	{
		symbol1 = "swap_staffs",
		symbol2 = "swap_bluestaff",
	},
	
	telestaff =
	{
		symbol1 = "swap_staffs",
		symbol2 = "swap_purplestaff",
	},
	
	yellowstaff =
	{
		symbol1 = "swap_staffs",
		symbol2 = "swap_yellowstaff",
	},
	
	orangestaff =
	{
		symbol1 = "swap_staffs",
		symbol2 = "swap_orangestaff",
	},
	
	greenstaff =
	{
		symbol1 = "swap_staffs",
		symbol2 = "swap_greenstaff",
	},
	
	opalstaff =
	{
		symbol1 = "swap_staffs",
		symbol2 = "swap_opalstaff",
	},
	
	staff_tornado =
	{
		symbol1 = "swap_tornado_stick",
		symbol2 = "swap_tornado_stick",
	},
	
	blowdart_pipe =
	{
		symbol1 = "swap_blowdart_pipe",
		symbol2 = "swap_blowdart_pipe",
	},
	
	blowdart_fire =
	{
		symbol1 = "swap_blowdart",
		symbol2 = "swap_blowdart",
	},
	
	blowdart_sleep =
	{
		symbol1 = "swap_blowdart",
		symbol2 = "swap_blowdart",
	},
	
	blowdart_yellow =
	{
		symbol1 = "swap_blowdart",
		symbol2 = "swap_blowdart",
	},
	
	houndstooth_blowpipe =
	{
		symbol1 = "swap_houndstooth_blowpipe",
		symbol2 = "swap_blowdart_pipe",
	},
	
	gnarwail_horn =
	{
		symbol1 = "gnarwail_horn",
		symbol2 = "swap_gnarwailhorn",
	},
	
	yotd_oar =
	{
		symbol1 = "yotd_oar",
		symbol2 = "swap_oar",
	},

	staff_lunarplant =
	{
		symbol1 = "staff_lunarplant",
		symbol2 = "staff_swap_lunarplant",
	},
	
	voidcloth_boomerang =
	{
		symbol1 = "boomerang_voidcloth",
		symbol2 = "boomerang_voidcloth",
	},
	
	voidcloth_scythe =
	{
		symbol1 = "scythe_voidcloth",
		symbol2 = "swap_scythe",
	},
	
	winona_telebrella =
	{
		symbol1 = "winona_telebrella",
		symbol2 = "swap_winona_telebrella",
	},
}

local function SymbolNamePostInit(inst)
	entry = TUNING.VANITY_SYMBOLNAMES[inst.prefab]

	if entry then
		inst.symbolname1 = entry.symbol1
		inst.symbolname2 = entry.symbol2
	end
end

for k, item in pairs(TUNING.VANITY_SYMBOLNAMES) do
	AddPrefabPostInit(k, SymbolNamePostInit)
end