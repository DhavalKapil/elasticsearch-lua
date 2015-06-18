-------------------------------------------------------------------------------
-- Importing module
-------------------------------------------------------------------------------
local Selector = require "selector.Selector"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local StickyRoundRobinSelector = Selector:new()

-------------------------------------------------------------------------------
-- Declaring instance variables
-------------------------------------------------------------------------------
local index = 1

-------------------------------------------------------------------------------
-- Selects next connection in roundrobin fashion only if the connection is
-- dead. Otherwise returns the last selected connection
--
-- @param   connections   A table of connections
-- @return  Connection    The connection selected
-------------------------------------------------------------------------------
function StickyRoundRobinSelector:selectNext(connections)
  -- Checking if connection is alive or not
  if connections[index].alive then
    return connections[index]
  end
  -- Else returning the next connection
  index = index + 1
  index = index % #connections
  if index == 0 then
    index = #connections
  end
  return connections[index]
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
