-------------------------------------------------------------------------------
-- Importing module
-------------------------------------------------------------------------------
local Selector = require "selector.Selector"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local RandomSelector = Selector:new()

-------------------------------------------------------------------------------
-- Randomly selects a connection from the list provided
--
-- @param   connections   A table of connections
-- @return  Connection    The connection selected
-------------------------------------------------------------------------------
function RandomSelector:selectNext(connections)
  -- Function body
end

-------------------------------------------------------------------------------
-- Returns an instance of RandomSelector class
-------------------------------------------------------------------------------
function RandomSelector:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return RandomSelector