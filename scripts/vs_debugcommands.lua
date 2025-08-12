-- Gives some vanity hand items.
function c_vsvanityhand()
	local player = ConsoleCommandPlayer()
	
	if player ~= nil then
		c_select(player)
		
		c_give("cane",          nil, true)
		c_give("spear",         nil, true)
		c_give("chum",          nil, true)
		c_give("bullkelp_root", nil, true)
		c_give("lantern",       nil, true)
    end
end

-- Gives some vanity body items.
function c_vsvanitybody()
	local player = ConsoleCommandPlayer()
	
	if player ~= nil then
		c_select(player)
		
		c_give("trunkvest_winter", nil, true)
		c_give("armorruins",       nil, true)
		c_give("hawaiianshirt",    nil, true)
		c_give("yellowamulet",     nil, true)
		c_give("krampus_sack",     nil, true)
    end
end

-- Gives some vanity head items.
function c_vsvanityhead()
	local player = ConsoleCommandPlayer()
	
	if player ~= nil then
		c_select(player)
		
		c_give("minerhat",  nil, true)
		c_give("icehat",    nil, true)
		c_give("winterhat", nil, true)
		c_give("ruinshat",  nil, true)
    end
end