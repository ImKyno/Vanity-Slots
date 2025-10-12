-- Common Dependencies.
local _G   = GLOBAL
local next = _G.next

AddComponentPostInit("sanity", function(self)
	local _SetInducedInsanity = self.SetInducedInsanity

	function self:SetInducedInsanity(src, val)
		if src ~= nil and src.vanity_insanity_blocker then
			if type(self.inducedinsanity_sources) == "table" then
				self.inducedinsanity_sources[src] = nil
				
				if next(self.inducedinsanity_sources) == nil then
					self.inducedinsanity_sources = nil
					self.inducedinsanity = nil
				end
			end

			return
		end

		return _SetInducedInsanity(self, src, val)
	end
end)