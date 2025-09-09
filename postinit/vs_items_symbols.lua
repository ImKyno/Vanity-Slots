-- Common Dependencies.
local _G            = GLOBAL
local require       = _G.require
local EQUIPSLOTS    = _G.EQUIPSLOTS
local UpvalueHacker = require("vs_upvaluehacker")

require("vs_tuning")

TUNING.VANITY_ACTIONS_HANDS =
{
	"bugnet",
	"bugnet_start",
	"catchfish",
	"catchonfire",
	"chop",
	"chop_start",
	"combat_lunge_start",
	"combat_lunge",
	"dig",
	"dig_start",
	"doswipeaction",
	"dojostleaction",
	"fishing",
	"fishing_nibble",
	"fishing_ocean_pre",
	"fishing_pre",
	"fishing_pst",
	"fishing_strain",
	"hammer",
	"hammer_start",
	"mine",
	"mine_start",
	"oceanfishing_cast",
	"oceanfishing_catch",
	"oceanfishing_idle",
	"oceanfishing_linesnapped",
	"oceanfishing_reel",
	"oceanfishing_sethook",
	"oceanfishing_stop",
	"pour",
	"terraform",
	"throw",
	"throw_deploy",
	"throw_keep_equip",
	"till",
	"till_start",
	"veryquickcastspell",
}

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
		symbol1 =
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