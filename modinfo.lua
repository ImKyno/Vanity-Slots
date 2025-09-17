local function ChooseTranslationTable(tbl)
    return tbl[locale] or tbl[1]
end

local STRINGS = 
{
	NAME = 
	{
		"Cosmetic Slots",
		zh  = "化妆品槽位 (Cosmetic Slots)",
		zht = "化妝品槽位 (Cosmetic Slots)",
		pt  = "Slots Cosméticos",
	},
	
	DESCRIPTION =
	{
[[
󰀞 Adds Cosmetic Slots for Hands, Body and Head to express your fashion desires without the need to give up on your actual equipment! Travel the Constant in a sizzling style!

󰀖 Have you ever wanted to use a skin but couldn't because the item itself wasn't that good? Now you can use any equippable item without worrying about whether it's actually equipped.

󰀏 Beware! Although items equipped in Cosmetic Slots don't lose durability or spoil, they do not provide their benefits to the player.

󰀏 Mod Configuration is entirely client. You can access it in: 
Main Menu → Mods → Server Mods → Cosmetic Slots

󰀌 Mod Version: 1.0-A
󰀧 Update: Mod Launch
]],
		zh  =
[[
󰀞 新增手部、身体和头部饰品槽，无需放弃现有装备，即可展现你的时尚渴望！以火辣风格畅游宇宙！

󰀖 你是否曾想过给某个物品添加皮肤，却因为物品本身不够好而无法实现？别担心！现在你可以使用任何可装备的物品，无需担心它是否真的被装备了。

󰀏 注意！虽然装备在装饰槽中的物品不会损失耐久度或损坏，但它们不会给玩家带来好处。

󰀏 模组配置完全在客户端进行。您可以通过以下方式访问：
主菜单 → 模组 → 服务器模组 → 外观栏

󰀌 Mod 版本： 1.0-A
󰀧 更新： Mod 发布
]],	
		zht =
[[
󰀞 新增手部、身体和头部饰品槽，无需放弃现有装备，即可展现你的时尚渴望！以火辣风格畅游宇宙！

󰀖 你是否曾想过给某个物品添加皮肤，却因为物品本身不够好而无法实现？别担心！现在你可以使用任何可装备的物品，无需担心它是否真的被装备了。

󰀏 注意！虽然装备在装饰槽中的物品不会损失耐久度或损坏，但它们不会给玩家带来好处。

󰀏 處置 模組配置完全在客戶端進行。您可以透過以下方式存取：
主選單 → 模組 → 伺服器模組 → 外觀欄

󰀌 Mod 版本： 1.0-A
󰀧 更新： Mod 发布
]],	
		pt  = 
[[
󰀞 Adiciona Slots Cosméticos para Cabeça, Corpo e Mãos para você expressar seus desejos de moda sem precisar sacrificar seu equipamento real! Caminhe pelo Constante em um estilo escaldante!
	
󰀖 Sempre quis utilizar aquela skin mas nunca fez por que o item não era tão bom assim? Sem problemas! Agora você pode equipar qualquer item sem precisar realmente equipá-lo!
	
󰀏 Atenção! Apesar de itens equipados nos Slots Cosméticos não perderem durabilidade ou estragarem, eles não garantem nenhum de seus benefícios ao jogador.

󰀏 A configuração do Mod é totalmente do cliente. Você pode acessá-la em:
Menu Principal → Mods → Mods de Servidor → Slots Cosméticos
	
󰀌 Versão do Mod: 1.0-A
󰀧 Atualização: Lançamento do Mod
]],
	},

	SETTINGS = 
	{
		CLIENT =
		{
			NAME =
			{
				"",
				zh  = "",
				zht = "",
				pt  = "",
			},
			
			DESCRIPTION =
			{
				"These Mod Options only applies to yourself.",
				zh  = "这些 Mod 选项仅适用于您自己。",
				zht = "這些 Mod 選項僅適用於您自己。",
				pt  = "Estas opções do Mod se aplicam somente a você.",
			},
		},
		
		SERVER =
		{
			NAME =
			{
				"",
				zh  = "",
				zht = "",
				pt  = "",
			},
			
			DESCRIPTION =
			{
				"Mod Configuration is entirely client.\nYou can access it in: Main Menu → Mods → Server Mods → Cosmetic Slots",
				zh  = "Mod 配置完全由客户端完成。\n您可以通过以下方式访问：主菜单 → Mods → 服务器 Mods → 装饰槽",
				zht = "Mod 配置完全由客戶端完成。 \n您可以透過以下方式存取：主選單 → Mods → 伺服器 Mods → 裝飾槽",
				pt  = "A configuração do Mod é inteiramente cliente.\nVocê pode acessá-la em: Menu Principal → Mods → Mods de Servidor → Slots Cosméticos",
			},
		},
		
		LANGUAGE =
		{
			NAME =
			{
				"Language",
				zh  = "语",
				zht = "話",
				pt  = "Idioma",
			},
			
			DESCRIPTION =
			{
				"Choose the language for the mod.\nYou can submit your translation in our Discord.",
				zh  = "选择模块的语言。 \n您可以在我们的 Discord 中提交您的翻译。",
				zht = "選擇模組的語言。 \n您可以在我們的 Discord 中提交您的翻譯。",
				pt  = "Escolha o idioma do Mod.\nVocê pode enviar sua tradução em nosso Discord.",
			},
			
			OPTIONS_DESCRIPTION =
			{
				en  = "English",
				zh  = "简体中文",
				zht = "繁體中文",
				pt  = "Português",
			},
		},
		
		KEYBIND = 
		{
			NAME = 
			{
				"Shortcut Key",
				zh  = "快捷键",
				zht = "快速鍵",
				pt  = "Tecla de Atalho",
			},
			
			DESCRIPTION = 
			{
				"Choose the Shortcut Key for the Cosmetic Slots widget.\nDefault Shortcut Key: Disabled",
				zh  = "选择装饰槽小部件的快捷键。 \n默认快捷键：已禁用",
				zht = "選擇裝飾槽小工具的快速鍵。 \n預設快速鍵：已停用",
				pt  = "Selecione a Tecla de Atalho para o widget dos Slots Cosméticos.\nTecla de Atalho padrão: Desativada",
			},
			
			DISABLED = 
			{
				"Disabled",
				zh  = "残疾人",
				zht = "殘障人士",
				pt  = "Desativado",
			},
		},
	},
}

name                        = ChooseTranslationTable(STRINGS.NAME)
version                     = "1.0-A"

description                 = ChooseTranslationTable(STRINGS.DESCRIPTION)

author                      = "Kyno"
api_version                 = 10
priority                    = -1 -- Above 0 = Override other mods. | Below 0 = Overriden by other mods.

dst_compatible              = true
all_clients_require_mod     = true
client_only_mod             = false

server_filter_tags          = {"Cosmetic Slots", "Vanity Slots", "VS", "Entertainment", "Kyno"}

icon                        = "ModiconVS.tex"
icon_atlas                  = "ModiconVS.xml"

-- For modders: Feel free to grab this key list!
local KEY_IDS               = 
{
    97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122,
    282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293,
    256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272,
    45, 61, 32, 13, 27, 278, 277, 127, 279,
    19, 316, 301, 302, 311, 312, 9, 400, 401, 402, 8, 46, 47,
    59, 91, 92, 93, 96,
    273, 274, 275, 276, 280, 281,
}

local KEY_NAMES             = 
{
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
    "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12",
    "Numpad 0", "Numpad 1", "Numpad 2", "Numpad 3", "Numpad 4", "Numpad 5", "Numpad 6", "Numpad 7", "Numpad 8", "Numpad 9",
    "Numpad .", "Numpad /", "Numpad *", "Numpad -", "Numpad +", "Numpad Enter", "Numpad =",
    "-", "=", "Spacebar", "Enter", "Escape", "Home", "Insert", "Delete", "End",
    "Pause", "Prt Scrn", "Caps lock", "Scroll Lock", "Left Windows", "Right Windows", "Tab", "Alt", "Ctrl", "Shift", "Backspace", ".", "/",
    ";", "[", "]", "\\", "~",
    "Arrow ↑", "Arrow ↓", "Arrow →", "Arrow ←", "Page Up", "Page Down",
}

local KEYLIST_DESCRIPTION   = ChooseTranslationTable(STRINGS.SETTINGS.KEYBIND.DISABLED)
local keylist               = {{description = KEYLIST_DESCRIPTION, data = false}}

for i = 1, #KEY_IDS do
	local fmt               = '{"id": %d, "name": "%s"}'
	local data              = fmt:format(KEY_IDS[i], KEY_NAMES[i])
	
    keylist[i + 1]          = {description = KEY_NAMES[i], data = data}
end

keylist[#keylist + 1]       = {description = KEYLIST_DESCRIPTION, data = false}


local LANGUAGE_LABEL        = ChooseTranslationTable(STRINGS.SETTINGS.LANGUAGE.NAME)
local LANGUAGE_HOVER        = ChooseTranslationTable(STRINGS.SETTINGS.LANGUAGE.DESCRIPTION)
local LANGUAGE_OPTIONS      =
{
	{
		description         = STRINGS.SETTINGS.LANGUAGE.OPTIONS_DESCRIPTION.en,
		data                = false, 
	},
	{
		description         = STRINGS.SETTINGS.LANGUAGE.OPTIONS_DESCRIPTION.zh,
		data                = "zh",
	},
	{
		description         = STRINGS.SETTINGS.LANGUAGE.OPTIONS_DESCRIPTION.zht,
		data                = "zht",
	},
	{
		description         = STRINGS.SETTINGS.LANGUAGE.OPTIONS_DESCRIPTION.pt,
		data                = "pt",
	},
}

local KEYBIND_LABEL         = ChooseTranslationTable(STRINGS.SETTINGS.KEYBIND.NAME)
local KEYBIND_HOVER         = ChooseTranslationTable(STRINGS.SETTINGS.KEYBIND.DESCRIPTION)

local SERVER_LABEL          = ChooseTranslationTable(STRINGS.SETTINGS.SERVER.NAME)
local SERVER_HOVER          = ChooseTranslationTable(STRINGS.SETTINGS.SERVER.DESCRIPTION)
local SERVER_OPTIONS        =
{
	{
		description         = "",
		data                = false,
	},
}

configuration_options       =
{
	{name                   = "LANGUAGE", label = LANGUAGE_LABEL, hover = LANGUAGE_HOVER, client = true,  options = LANGUAGE_OPTIONS, default = false},
	{name                   = "KEYBIND",  label = KEYBIND_LABEL,  hover = KEYBIND_HOVER,  client = true,  options = keylist,          default = false},
	{name                   = "SERVER",   label = SERVER_LABEL,   hover = SERVER_HOVER,   client = false, options = SERVER_OPTIONS,   default = false},
}