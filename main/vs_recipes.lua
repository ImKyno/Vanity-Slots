-- Common Dependencies.
local _G                   = GLOBAL
local TECH                 = _G.TECH
local Ingredient           = _G.Ingredient
local SanityIngredient     = _G.CHARACTER_INGREDIENT.SANITY

-- Pantomimed Items Recipes.
AddRecipe2("vanity_hands_item", {Ingredient("featherpencil", 0)}, TECH.NONE,
	{
		no_deconstruction   = true,
		atlas 				= "images/inventoryimages/vanity_clothing.xml",
		image 				= "vanity_hands_item.tex",
	},
	{"CLOTHING"}
)

AddRecipe2("vanity_body_item", {Ingredient("featherpencil", 0)}, TECH.NONE,
	{
		no_deconstruction   = true,
		atlas 				= "images/inventoryimages/vanity_clothing.xml",
		image 				= "vanity_body_item.tex",
	},
	{"CLOTHING"}
)

AddRecipe2("vanity_head_item", {Ingredient("featherpencil", 0)}, TECH.NONE,
	{
		no_deconstruction   = true,
		atlas 				= "images/inventoryimages/vanity_clothing.xml",
		image 				= "vanity_head_item.tex",
	},
	{"CLOTHING"}
)

AddCharacterRecipe("vanity_hands_item_wes", {Ingredient("featherpencil", 0)}, TECH.NONE,
	{
		product     = "vanity_hands_item",
		builder_tag = "mime",
		atlas       = "images/inventoryimages/vanity_clothing.xml",
		image       = "vanity_hands_item.tex",
	}
)

AddCharacterRecipe("vanity_body_item_wes", {Ingredient("featherpencil", 0)}, TECH.NONE,
	{
		product     = "vanity_body_item",
		builder_tag = "mime",
		atlas       = "images/inventoryimages/vanity_clothing.xml",
		image       = "vanity_body_item.tex",
	}
)

AddCharacterRecipe("vanity_head_item_wes", {Ingredient("featherpencil", 0)}, TECH.NONE,
	{
		product     = "vanity_head_item",
		builder_tag = "mime",
		atlas       = "images/inventoryimages/vanity_clothing.xml",
		image       = "vanity_head_item.tex",
	}
)