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
-- The request params to be sent as GET parameters
Endpoint.params = {}
-- The body of the request
Endpoint.body = {}
-- The transport instance
Endpoint.transport = nil

-------------------------------------------------------------------------------
-- Function used to set the params to be sent as GET parameters
--
-- @param   params  The params provided by the user
-------------------------------------------------------------------------------
function Endpoint:setParams(params)
  for i, v in pairs(params) do
    if i == "index" then
      self.index = v
    elseif i == "type" then
      self.type = v
    elseif i == "id" then
      self.id = v
    elseif i == "body" then
      self.body = v
    else
      self.params[i] = v
    end
  end
end

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
