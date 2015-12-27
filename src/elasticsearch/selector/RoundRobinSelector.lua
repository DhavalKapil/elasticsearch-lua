-------------------------------------------------------------------------------
-- Importing module
-------------------------------------------------------------------------------
local Selector = require "elasticsearch.selector.Selector"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local RoundRobinSelector = Selector:new()

-------------------------------------------------------------------------------
-- Declaring instance variables
-------------------------------------------------------------------------------
RoundRobinSelector.index = 0

-------------------------------------------------------------------------------
-- Selects the next connection from the list in round robin fashion
--
-- @param   connections   A table of connections
-- @return  Connection    The connection selected
-------------------------------------------------------------------------------
function RoundRobinSelector:selectNext(connections)
  self.index = self.index + 1
  self.index = self.index % #connections
  if self.index == 0 then
    self.index = #connections
  end
  return connections[self.index]
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
