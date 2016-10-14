-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local IndicesEndpoint = require "elasticsearch.endpoints.Indices.IndicesEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local DeleteTemplate = IndicesEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
DeleteTemplate.allowedParams = {
  ["timeout"] = true,
  ["master_timeout"] = true
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
  if self.name == nil then
    return nil, "Name not specified for DeleteTemplate"
  end

  local uri = "/_template/" .. self.name
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
