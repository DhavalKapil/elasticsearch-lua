-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local IndicesEndpoint = require "elasticsearch.endpoints.Indices.IndicesEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local DeleteWarmer = IndicesEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
DeleteWarmer.allowedParams = {
  ["name"] = true,
  ["master_timeout"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function DeleteWarmer:getMethod()
  return "DELETE"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function DeleteWarmer:getUri()
  if self.index == nil then
    return nil, "index not specified for Delete Warmer"
  elseif self.name == nil then
    return nil, "name not specified for Delete Warmer"
  end
  local uri = "/" .. self.index .. "/_warmer/" .. self.name
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of DeleteWarmer class
-------------------------------------------------------------------------------
function DeleteWarmer:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return DeleteWarmer
