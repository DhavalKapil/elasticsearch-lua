-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local IndicesEndpoint = require "elasticsearch.endpoints.Indices.IndicesEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local PutTemplate = IndicesEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
PutTemplate.allowedParams = {
  ["order"] = true,
  ["create"] = true,
  ["timeout"] = true,
  ["master_timeout"] = true,
  ["flat_settings"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function PutTemplate:getMethod()
  return "PUT"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function PutTemplate:getUri()
  if self.name == nil then
    return nil, "name not specified for Put Template"
  end

  local uri = "/_template/" .. self.name
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of PutTemplate class
-------------------------------------------------------------------------------
function PutTemplate:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return PutTemplate
