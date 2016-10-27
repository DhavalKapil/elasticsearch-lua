--- The Transport class
-- @classmod Transport
-- @author Dhaval Kapil

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
    return nil, "No alive node found"
  end
  -- Making request
  local response = connection:request(method, uri, params, body)
  if response.code ~= nil then
    -- Response returned
    self.retryCount = 0
    connection:markAlive()
    -- Check for statusCode
    if response.statusCode >= 400 and response.statusCode < 500 then
      return nil, "ClientError: Invalid response code: " .. response.statusCode
    elseif response.statusCode >= 500 and response.statusCode < 600 then
      return nil, "ServerError: Invalid response code: " .. response.statusCode
    end
    return response
  end
  connection:markDead()
  -- Checking if another connection should be tried or not
  if self.retryCount < self.maxRetryCount then
    self.retryCount = self.retryCount + 1
    return self:request(method, uri, params, body)
  end
  return nil, "TransportError"
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