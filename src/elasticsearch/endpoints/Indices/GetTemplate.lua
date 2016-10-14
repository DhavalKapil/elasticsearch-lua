-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local IndicesEndpoint = require "elasticsearch.endpoints.Indices.IndicesEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local GetTemplate = IndicesEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
GetTemplate.allowedParams = {
  ["flat_settings"] = true,
  ["master_timeout"] = true,
  ["local"] = true
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
  local uri = "/_template"

  if self.name ~= nil then
    uri = uri .. "/" .. self.name
  end
  
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
