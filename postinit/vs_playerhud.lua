-- Common Dependencies.
local _G              = GLOBAL
local require         = _G.require
local ContainerWidget = require("widgets/containerwidget")
local UpvalueHacker   = require("vs_upvaluehacker")

-- Workaround for attaching the container to the inventory root.
AddClassPostConstruct("screens/playerhud", function(self)
	local _OpenContainerWidget = UpvalueHacker.GetUpvalue(self.OpenContainer, "OpenContainerWidget")
	
	local function OpenContainerWidget(self, container, side, ...)
		local _container = container.replica.container
		local _type = _container and _container.type or nil

		if _type ~= "vanity" then
			return _OpenContainerWidget(self, container, side, ...)
		end

		local inventory = _G.ThePlayer ~= nil and _G.ThePlayer.replica.inventory
		local containerwidget = ContainerWidget(self.owner)
		local parent = (_type == "vanity" and self.controls.inv) or self.controls.containerroot

		parent:AddChild(containerwidget)

		containerwidget:SetScale(.96, .96, .96)
		containerwidget:MoveToBack()
		containerwidget:Open(container, self.owner)
		self.controls.containers[container] = containerwidget
		self.controls.inv:OnNewContainerWidget(containerwidget)

		if parent == self.controls.containerroot then
			self:CloseSpellWheel()
		end
	end
	
	UpvalueHacker.SetUpvalue(self.OpenContainer, OpenContainerWidget, "OpenContainerWidget")
end)