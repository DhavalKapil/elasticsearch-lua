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
-- StickyRoundRobinly selects a connection from the list provided
--
-- @param   connections   A table of connections
-- @return  Connection    The connection selected
-------------------------------------------------------------------------------
function StickyRoundRobinSelector:selectNext(connections)
  -- Checking if connection is alive or not
  if connections[index]:ping() then
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
