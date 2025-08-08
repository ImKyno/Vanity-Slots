require("constants")

local VANITY_SLOTS = {}

-- Insert our slot into EQUIPSLOTS table.
VANITY_SLOTS = 
{
	VANITY = "vanity",
}

for slot, id in pairs(VANITY_SLOTS) do
    if id then
        EQUIPSLOTS[slot] = id
    end
end