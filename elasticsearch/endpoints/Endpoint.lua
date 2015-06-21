-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Endpoint = {}

-------------------------------------------------------------------------------
-- Declaring instance variables
-------------------------------------------------------------------------------

-- The index
Endpoint.index = nil
-- The type
Endpoint.type = nil
-- The id
Endpoint.id = nil
-- The request method
Endpoint.method = nil
-- The request URI
Endpoint.uri = nil
-- The request method
Endpoint.params = nil
-- The body of the request
Endpoint.body = {}
-- The transport instance
Endpoint.transport = nil

-------------------------------------------------------------------------------
-- Makes a request using the instance of transport class
--
-- @return  table   The reponse returned
-------------------------------------------------------------------------------
function Endpoint:request()
  local result = self.transport:request(self.method, self.uri, self.params
    , self.body)
  return result
end

-------------------------------------------------------------------------------
-- Returns an instance of Endpoint class
-------------------------------------------------------------------------------
function Endpoint:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Endpoint
