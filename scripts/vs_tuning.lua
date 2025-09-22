TUNING.VANITYSLOTS_MAXSLOTS = 3 -- Unused.

TUNING.VANITYSLOTS_WIDGET_XPOS = 875
TUNING.VANITYSLOTS_WIDGET_YPOS = 73
TUNING.VANITYSLOTS_WIDGET_XPOS_MOD = 1010
TUNING.VANITYSLOTS_WIDGET_YPOS_MOD = 73

TUNING.EQUIPSLOTS_VANITYSLOTS_INDEX =
{
	[EQUIPSLOTS.HANDS] = 1,
	[EQUIPSLOTS.BODY]  = 2,
	[EQUIPSLOTS.HEAD]  = 3,
}

TUNING.VANITY_COMMON_HEAD_ITEMS =
{
	"head_test",
}

TUNING.VANITY_COMMON_BODY_ITEMS =
{
	"body_test",
}

TUNING.VANITY_COMMON_HANDS_ITEMS =
{
	"hands_test",
}

TUNING.VANITY_MUSHROOM_HEAD_ITEMS =
{
	"red_mushroomhat",
	"green_mushroomhat",
	"blue_mushroomhat",
	"moon_mushroomhat",
}

TUNING.VANITY_PILLOW_BODY_ITEMS =
{
	"bodypillow_beefalowool",
	"bodypillow_kelp",
	"bodypillow_steelwool",
}

TUNING.VANITY_HASFX_ITEMS =
{
	"minifan",
	"shadow_battleaxe",
	"slingshot",
	"spear_wathgrithr_lightning_charged",
	"staff_lunarplant",
	"sword_lunarplant",
	"voidcloth_boomerang",
	"voidcloth_scythe",
	"voidcloth_umbrella",
	"winona_telebrella",
	"wortox_nabbag",
	"wurt_swampitem_shadow",
	"wurt_swampitem_lunar",
}

TUNING.VANITY_PERSISTSFX_ITEMS =
{
	"staff_lunarplant",
	"sword_lunarplant",
}

TUNING.VANITY_MULTIPLEFX_ITEMS =
{
	"slingshot",
}

TUNING.VANITY_TOGGABLEFX_ITEMS =
{
	"shadow_battleaxe",
	"voidcloth_boomerang",
	"voidcloth_scythe",
}

-- Items that have inverted symbols when skinned. (Using our crap system)
TUNING.VANITY_INVERTEDSYMBOL_ITEMS =
{
	"spear_wathgrithr_lightning",
	"spear_wathgrithr_lightning_charged",
	"firestaff",
	"icestaff",
	"orangestaff",
	"yellowstaff",
	"greenstaff",
	"telestaff",
	"opalstaff",
}

-- Items that can't go in containers.
TUNING.VANITY_RESTRICTED_ITEMS =
{
	"backpack",
	"candybag",
	"icepack",
	"krampus_sack",
	"piggyback",
	"seedpouch",
	"spicepack",
}

-- Items that can't be equipped regardless.
TUNING.VANITY_FORBID_ITEMS =
{
	"bishophead",
	"knighthead",
	"mermarmorhat",
	"mermarmorupgradedhat",
	"rooknose",
	-- And all other statues, oversized crops, etc.
}

TUNING.VANITY_WEREMODES =
{
	"beaver",
	"moose",
	"goose",
}

TUNING.VANITY_ATTACK_TAGS =
{
	"book",
	"extinguisher",
	"firepen",
	"jab",
	"pocketwatch",
	"rangedweapon",
	"vanity_alt_attack",
	"whip",
}

-- Stategraph events that does not have "onexit" state.
TUNING.VANITY_STATES_ONEXIT =
{
	"attack_pillow",
	"attack_pillow_pre",
	"attack_prop_pre",
	"bugnet",
	"bugnet_start",
	"catchonfire",
	"combat_lunge_start",
	"fishing",
	"fishing_ocean_pre",
	"fishing_pre",
	"fishing_pst",
	"oceanfishing_cast",
	"oceanfishing_linesnapped",
	"oceanfishing_stop",
	"play_gnarwail_horn",
	"play_strum",
	"quickcastspell",
	"scythe",
	"spray_wax",
	"terraform",
	"throw_keep_equip",
	"till",
	"till_start",
	"veryquickcastspell",
}

TUNING.VANITY_STATES_NAMES =
{
	"attack_pillow",
	"attack_pillow_pre",
	"attack_prop_pre",
	"attack_prop",
	"blowdart",
	"bugnet",
	"bugnet_start",
	"castspell",
	"catchfish",
	"catchonfire",
	"chop",
	"chop_start",
	"combat_lunge",
	"combat_lunge_start",
	"dig",
	"dig_start",
	"dojostleaction",
	"doswipeaction",
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
	"play_gnarwail_horn",
	"play_strum",
	"pour",
	"quickcastspell",
	"quicktele",
	"row",
	"row_fail",
	"scythe",
	"spray_wax",
	"terraform",
	"throw",
	"throw_deploy",
	"throw_keep_equip",
	"till",
	"till_start",
	"unsaddle",
	"veryquickcastspell",
}