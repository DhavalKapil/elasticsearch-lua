-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local ConnectionPool = {}

-------------------------------------------------------------------------------
-- Declaring instance variables
-------------------------------------------------------------------------------

-- The list of all connections
local ConnectionPool.connections = {}
-- The selector instance
local ConnectionPool.selector = nil

-------------------------------------------------------------------------------
-- Returns an instance of ConnectionPool class
-------------------------------------------------------------------------------
function ConnectionPool:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return ConnectionPool