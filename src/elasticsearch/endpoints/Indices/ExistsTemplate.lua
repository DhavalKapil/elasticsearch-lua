-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local IndicesEndpoint = require "elasticsearch.endpoints.Indices.IndicesEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local ExistsTemplate = IndicesEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
ExistsTemplate.allowedParams = {
  ["master_timeout"] = true,
  ["local"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function ExistsTemplate:getMethod()
  return "HEAD"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function ExistsTemplate:getUri()
  if self.name == nil then
    return nil, "Name not specified for Exists Template"
  end

  local uri = "/_template/" .. self.name
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of ExistsTemplate class
-------------------------------------------------------------------------------
function ExistsTemplate:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return ExistsTemplate
