name                        = "Project Vanity"
version                     = "1.0-A"

description                 = 
[[
󰀞 Adds Cosmetic Slots for Hands, Body and Head to express your fashion desires without the need to give up on your actual equipment! Travel the Constant in a sizzling style!

󰀖 Have you ever wanted to use a skin but couldn't because the item itself wasn't that good? Now you can use any equippable item without worrying about whether it's actually equipped.

󰀏 Beware! Although items equipped in Cosmetic Slots don't lose durability or spoil, they do not provide their benefits to the player. 

󰀌 Mod Version: Alpha-2.0-A
󰀧 Update: In Development
]]

author                      = "Kyno"
api_version                 = 10
priority                    = -1 -- Above 0 = Override other mods. | Below 0 = Overriden by other mods.

dst_compatible              = true
all_clients_require_mod     = true
client_only_mod             = false

server_filter_tags          = {"Cosmetic Slots", "Vanity Slots", "VS", "Entertainment", "Kyno"}

icon                        = "ModiconVS.tex"
icon_atlas                  = "ModiconVS.xml"

-- Localizations.
if locale == "pt" then
	name                    = "Slots Cosméticos"
	description             =
[[
󰀞 Adiciona Slots Cosméticos para Cabeça, Corpo e Mãos para você expressar seus desejos de moda sem precisar sacrificar seu equipamento real! Caminhe pelo Constante em um estilo escaldante!
	
󰀖 Sempre quis utilizar aquela skin mas nunca fez por que o item não era tão bom assim? Sem problemas! Agora você pode equipar qualquer item sem precisar realmente equipá-lo!
	
󰀏 Atenção! Apesar de itens equipados nos Slots Cosméticos não perderem durabilidade ou estragarem, eles não garantem nenhum de seus benefícios ao jogador.
	
󰀌 Versão do Mod: 1.0-A
󰀧 Atualização: Lançamento do Mod
]]
end

if locale == "zh" then
	name                    = "化妆品槽位 (Cosmetic Slots)"
	description             =
[[
󰀞 新增手部、身体和头部饰品槽，无需放弃现有装备，即可展现你的时尚渴望！以火辣风格畅游宇宙！

󰀖 你是否曾想过给某个物品添加皮肤，却因为物品本身不够好而无法实现？别担心！现在你可以使用任何可装备的物品，无需担心它是否真的被装备了。

󰀏 注意！虽然装备在装饰槽中的物品不会损失耐久度或损坏，但它们不会给玩家带来好处。

󰀌 Mod 版本： 1.0-A
󰀧 更新： Mod 发布
]]
end

if locale == "zhr" then
	name                    = "化妝品槽位 (Cosmetic Slots)"
	description             =
[[
󰀞 新增手部、身體和頭部飾品槽，無需放棄現有裝備，即可展現你的時尚渴望！以火辣風格暢遊宇宙！

󰀖 你是否曾經想用某個皮膚，卻因為物品本身不夠好而無法使用？現在，你可以使用任何可裝備的物品，而無需擔心它是否真的被裝備了。

󰀏 注意！雖然裝備在裝飾槽中的物品不會損失耐久度或損壞，但它們不會為玩家帶來好處。

󰀌 Mod 版本: 1.0-A
󰀧 更新: Mod 發射
]]
end