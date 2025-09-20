-- Common Dependencies.
local _G                   = GLOBAL
local TECH                 = _G.TECH
local Ingredient           = _G.Ingredient
local SanityIngredient     = _G.CHARACTER_INGREDIENT.SANITY

-- Pantomimed Items Recipes.
AddRecipe2("vanity_hands_item", {Ingredient(SanityIngredient, 0)}, TECH.NONE,
	{
		no_deconstruction   = true,
		atlas 				= "images/inventoryimages/vanity_clothing.xml",
		image 				= "vanity_hands_item.tex",
	},
	{"CLOTHING"}
)

AddRecipe2("vanity_body_item", {Ingredient(SanityIngredient, 0)}, TECH.NONE,
	{
		no_deconstruction   = true,
		atlas 				= "images/inventoryimages/vanity_clothing.xml",
		image 				= "vanity_body_item.tex",
	},
	{"CLOTHING"}
)

AddRecipe2("vanity_head_item", {Ingredient(SanityIngredient, 0)}, TECH.NONE,
	{
		no_deconstruction   = true,
		atlas 				= "images/inventoryimages/vanity_clothing.xml",
		image 				= "vanity_head_item.tex",
	},
	{"CLOTHING"}
)