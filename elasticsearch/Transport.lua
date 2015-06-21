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
-- The number of retry attempts
Transport.retryCount = 0
-- The allowed no of retries
Transport.maxRetryCount = nil

-------------------------------------------------------------------------------
-- Returns the next connection from the ConnectionPool
--
-- @return  table   An instance of Connection
-------------------------------------------------------------------------------
function Transport:getConnection()
  return self.connectionPool:nextConnection()
end

-------------------------------------------------------------------------------
-- Makes a request to using a connection
--
-- @param   method  The HTTP method to be used
-- @param   uri     The HTTP URI for the request
-- @param   params  The optional URI parameters to be passed
-- @param   body    The body to passed if any
--
-- @return  table   The reponse returned
-------------------------------------------------------------------------------
function Transport:request(method, uri, params, body)
  -- Selecting a connection
  local connection = self:getConnection()
  if connection == nil then
    error("No connection available")
  end
  -- Making request
  local response = connection:request(method, uri, params, body)
  if response.code ~= nil and response.statusCode == 200 then
    -- Successfull response
    self.retryCount = 0
    connection:markAlive()
    return response
  end
  connection:markDead()
  -- Checking if another connection should be tried or not
  if self.retryCount < self.maxRetryCount then
    self.retryCount = self.retryCount + 1
    return self:request(method, uri, params, body)
  end
  error("Connection error")
end

-------------------------------------------------------------------------------
-- Returns an instance of Transport class
-------------------------------------------------------------------------------
function Transport:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Transport