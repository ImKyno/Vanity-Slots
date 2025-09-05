-- Change to true if you want the container to start closed.
TUNING.VANITYSLOTS_STARTCLOSED = false
TUNING.VANITY_SLOTS_MAXSLOTS = 3

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
	-- "propsign", -- Moved to his own postinit.
	"seedpouch",
	"spicepack",
	-- "slurper", -- Moved to his own postinit.
}

-- Items that can't be equipped regardless.
TUNING.VANITY_FORBID_ITEMS =
{
	"bishophead",
	"knighthead",
	"mermarmorhat", -- Merm hats are forbid because their animations don't work for players.
	"mermarmorupgradedhat",
	-- "merm_tool",
	-- "merm_tool_upgraded",
	"rooknose",
	-- And all other statues, oversized crops, etc.
}

-- In case some mod adds new Woodie weremodes.
TUNING.VANITY_WEREMODES =
{
	"beaver",
	"moose",
	"goose",
}