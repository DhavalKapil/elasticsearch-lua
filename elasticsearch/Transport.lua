-------------------------------------------------------------------------------
-- Importing module
-------------------------------------------------------------------------------
local parser = require "parser"
-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Transport = {}

-------------------------------------------------------------------------------
-- Declaring instance variables
-------------------------------------------------------------------------------

-- The ConnectionPool instance
Transport.connectionPool = nil

-------------------------------------------------------------------------------
-- Returns the next connection from the ConnectionPool
--
-- @return  table   An instance of Connection
-------------------------------------------------------------------------------
function Transport:getConnection()
  -- Function body
end

-------------------------------------------------------------------------------
-- Makes a request to using a connection
--
-- @param   params  The parameters to be passed
-- @return  table   The reponse returned
-------------------------------------------------------------------------------
function Transport:request(params)
  -- Function body
end

-------------------------------------------------------------------------------
-- Returns an instance of ConnectionPool class
-------------------------------------------------------------------------------
function ConnectionPool:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Transport