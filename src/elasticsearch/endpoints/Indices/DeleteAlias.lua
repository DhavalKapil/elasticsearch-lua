-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local IndicesEndpoint = require "elasticsearch.endpoints.Indices.IndicesEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local DeleteAlias = IndicesEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
DeleteAlias.allowedParams = {
  ["timeout"] = true,
  ["master_timeout"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function DeleteAlias:getMethod()
  return "DELETE"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function DeleteAlias:getUri()
  if self.index == nil then
    return nil, "Index not specified for DeleteAlias"
  elseif self.name == nil then
    return nil, "Name not specified for DeleteAlias"
  end
  local uri = "/" .. self.index .. "/_alias/" .. self.name
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of DeleteAlias class
-------------------------------------------------------------------------------
function DeleteAlias:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return DeleteAlias
