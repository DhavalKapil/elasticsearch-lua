-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "elasticsearch.endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Index = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
Index.allowedParams = {
  ["consistency"] = true,
  ["op_type"] = true,
  ["parent"] = true,
  ["refresh"] = true,
  ["routing"] = true,
  ["timeout"] = true,
  ["timestamp"] = true,
  ["ttl"] = true,
  ["version"] = true,
  ["version_type"] = true
}

-- Whether to create an index if it's absent
Index.endpointParams.createIfAbsent = false

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function Index:getMethod()
  if self.id ~= nil then
    return "PUT"
  else
    return "POST"
  end
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function Index:getUri()
  if self.index == nil then
    return nil, "index not specified for Index"
  end
  local uri = "/" .. self.index .. "/_doc"
  if self.id ~= nil then
    uri = uri .. "/" .. self.id
  end
  if self.endpointParams.createIfAbsent == true then
    self.params["op_type"] = "create"
  end
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of Index class
-------------------------------------------------------------------------------
function Index:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Index
