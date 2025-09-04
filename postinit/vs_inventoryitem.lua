-- Common Dependencies.
local _G   = GLOBAL
local next = _G.next

-- Workaround to keep items that can't go inside containers equipped.
AddComponentPostInit("inventoryitem", function(self)
    local _OnSave = self.OnSave
    function self:OnSave()
        local data, refs = nil, nil

        if _OnSave ~= nil then
            data, refs = _OnSave()
        end

        data = data or {}

        if self.__cangoincontainer ~= nil then
            data.cangoincontainer = self.__cangoincontainer
        end

        return next(data) ~= nil and data or nil, refs
    end

    local _OnLoad = self.OnLoad
    function self:OnLoad(data)
        if _OnLoad ~= nil then
            _OnLoad(data)
        end
        
        if data ~= nil and data.cangoincontainer ~= nil then
            self.cangoincontainer = true
            self.__cangoincontainer = data.cangoincontainer
        end
    end
end)