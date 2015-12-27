-------------------------------------------------------------------------------
-- Importing module
-------------------------------------------------------------------------------
local Selector = require "elasticsearch.selector.Selector"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local StickyRoundRobinSelector = Selector:new()

-------------------------------------------------------------------------------
-- Declaring instance variables
-------------------------------------------------------------------------------
StickyRoundRobinSelector.index = 1

-------------------------------------------------------------------------------
-- Selects next connection in roundrobin fashion only if the connection is
-- dead. Otherwise returns the last selected connection
--
-- @param   connections   A table of connections
-- @return  Connection    The connection selected
-------------------------------------------------------------------------------
function StickyRoundRobinSelector:selectNext(connections)
  -- Checking if connection is alive or not
  if connections[self.index].alive then
    return connections[self.index]
  end
  -- Else returning the next connection
  self.index = self.index + 1
  self.index = self.index % #connections
  if self.index == 0 then
    self.index = #connections
  end
  return connections[self.index]
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
