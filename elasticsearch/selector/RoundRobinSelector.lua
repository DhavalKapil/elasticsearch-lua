-------------------------------------------------------------------------------
-- Importing module
-------------------------------------------------------------------------------
local Selector = require "selector.Selector"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local RoundRobinSelector = Selector:new()

-------------------------------------------------------------------------------
-- Declaring instance variables
-------------------------------------------------------------------------------
local index = 0

-------------------------------------------------------------------------------
-- Selects the next connection from the list in round robin fashion
--
-- @param   connections   A table of connections
-- @return  Connection    The connection selected
-------------------------------------------------------------------------------
function RoundRobinSelector:selectNext(connections)
  index = index + 1
  index = index % #connections
  if index == 0 then
    index = #connections
  end
  return connections[index]
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
