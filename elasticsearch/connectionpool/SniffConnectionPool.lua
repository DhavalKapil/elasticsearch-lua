-------------------------------------------------------------------------------
-- Importing module
-------------------------------------------------------------------------------
local ConnectionPool = require "connectionpool.ConnectionPool"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local SniffConnectionPool = ConnectionPool:new()

-------------------------------------------------------------------------------
-- Returns the next connection from the connections table
--
-- @return  table   An instance of Connection
-------------------------------------------------------------------------------
function SniffConnectionPool:nextConnection()
  -- Function body
end

-------------------------------------------------------------------------------
-- Returns an instance of SniffConnectionPool class
-------------------------------------------------------------------------------
function SniffConnectionPool:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return SniffConnectionPool
