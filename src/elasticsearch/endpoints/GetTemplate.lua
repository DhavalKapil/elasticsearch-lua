-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local TemplateEndpoint = require "elasticsearch.endpoints.TemplateEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local GetTemplate = TemplateEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
GetTemplate.allowedParams = {
  ["version"] = true,
  ["version_type"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function GetTemplate:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function GetTemplate:getUri()
  if self.id == nil then
    return nil, "id required for Get Template"
  end
  local uri = "/_search/template/" .. self.id
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of GetTemplate class
-------------------------------------------------------------------------------
function GetTemplate:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return GetTemplate
