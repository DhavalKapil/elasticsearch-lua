-------------------------------------------------------------------------------
-- Importing module
-------------------------------------------------------------------------------
local Selector = require "elasticsearch.selector.Selector"

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
  return connections[math.random(1, #connections)]
end

-------------------------------------------------------------------------------
-- Returns an instance of RandomSelector class
-------------------------------------------------------------------------------
function RandomSelector:new(o)
  o = o or {}
  math.randomseed(os.time())
  setmetatable(o, self)
  self.__index = self
  return o
end

return RandomSelector
