-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local TemplateEndpoint = require "elasticsearch.endpoints.TemplateEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local DeleteTemplate = TemplateEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
DeleteTemplate.allowedParams = {
  ["version"] = true,
  ["version_type"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function DeleteTemplate:getMethod()
  return "DELETE"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function DeleteTemplate:getUri()
  if self.id == nil then
    return nil, "id required for Delete Template"
  end
  local uri = "/_search/template/" .. self.id
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of DeleteTemplate class
-------------------------------------------------------------------------------
function DeleteTemplate:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return DeleteTemplate
