-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local TemplateEndpoint = require "elasticsearch.endpoints.TemplateEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local PutTemplate = TemplateEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
PutTemplate.allowedParams = {
  ["op_type"] = true,
  ["version"] = true,
  ["version_type"] = true
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
  if self.id == nil then
    return nil, "id required for Put Template"
  end
  local uri = "/_search/template/" .. self.id
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
