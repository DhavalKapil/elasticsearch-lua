-------------------------------------------------------------------------------
-- Importing module
-------------------------------------------------------------------------------
local ConnectionPool = require "connectionpool.ConnectionPool"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local StaticConnectionPool = ConnectionPool:new()

-------------------------------------------------------------------------------
-- Returns the next connection from the connections table
--
-- @return  table   An instance of Connection
-------------------------------------------------------------------------------
function StaticConnectionPool:nextConnection()
  -- Function body
end

-------------------------------------------------------------------------------
-- Returns an instance of StaticConnectionPool class
-------------------------------------------------------------------------------
function StaticConnectionPool:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return StaticConnectionPool