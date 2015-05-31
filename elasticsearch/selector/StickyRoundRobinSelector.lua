-------------------------------------------------------------------------------
-- Importing module
-------------------------------------------------------------------------------
local Selector = require "selector.Selector"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local StickyRoundRobinSelector = Selector:new()

-------------------------------------------------------------------------------
-- StickyRoundRobinly selects a connection from the list provided
--
-- @param		connections	A table of connections
-- @return 	Connection 	The connection selected
-------------------------------------------------------------------------------
function StickyRoundRobinSelector:selectNext(connections)
	-- Function body
end

-------------------------------------------------------------------------------
-- Returns an instance of StickyRoundRobinSelector class
-------------------------------------------------------------------------------
function StickyRoundRobinSelector:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

return StickyRoundRobinSelector