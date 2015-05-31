-------------------------------------------------------------------------------
-- Importing module
-------------------------------------------------------------------------------
local Selector = require "selector.Selector"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local RoundRobinSelector = Selector:new()

-------------------------------------------------------------------------------
-- RoundRobinly selects a connection from the list provided
--
-- @param		connections	A table of connections
-- @return 	Connection 	The connection selected
-------------------------------------------------------------------------------
function RoundRobinSelector:selectNext(connections)
	-- Function body
end

-------------------------------------------------------------------------------
-- Returns an instance of RoundRobinSelector class
-------------------------------------------------------------------------------
function RoundRobinSelector:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

return RoundRobinSelector