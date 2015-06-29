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
-- The request params
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
  local uri, err = self:getUri()
  if uri == nil then
    return nil, err
  end
  local result, err = self.transport:request(self:getMethod(), self:getUri()
    , self.params, self.body)
  return result, err
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
