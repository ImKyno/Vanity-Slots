-- Change to true if you want the container to start closed.
TUNING.VANITYSLOTS_STARTCLOSED = false
TUNING.VANITY_SLOTS_MAXSLOTS = 3 -- Unused.

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
	"bugnet",
	"bugnet_start",
	"catchonfire",
	"combat_lunge_start",
	"fishing",
	"fishing_ocean_pre",
	"fishing_pre",
	"fishing_pst",
	"play_gnarwail_horn",
	"play_strum",
	"oceanfishing_cast",
	"oceanfishing_linesnapped",
	"oceanfishing_stop",
	"terraform",
	"till",
	"till_start",
	"throw_keep_equip",
	"veryquickcastspell",
	"quickcastspell",
	-- "row_idle",
}

TUNING.VANITY_STATES_NAMES =
{
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
	"terraform",
	"throw",
	"throw_deploy",
	"throw_keep_equip",
	"till",
	"till_start",
	"veryquickcastspell",
	"unsaddle",
	"row",
	"row_fail",
	-- "row_idle",
}