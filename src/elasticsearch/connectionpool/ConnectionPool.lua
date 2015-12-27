-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local ConnectionPool = {}

-------------------------------------------------------------------------------
-- Declaring instance variables
-------------------------------------------------------------------------------

-- The list of all connections
ConnectionPool.connections = {}
-- The selector instance
ConnectionPool.selector = nil
-- The logger instance
ConnectionPool.logger = nil

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