-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local IndicesEndpoint = require "elasticsearch.endpoints.Indices.IndicesEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local PutAlias = IndicesEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
PutAlias.allowedParams = {
  ["timeout"] = true,
  ["master_timeout"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function PutAlias:getMethod()
  return "PUT"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function PutAlias:getUri()
  if self.index == nil then
    return nil, "Index not specified for PutAlias"
  elseif self.name == nil then
    return nil, "Name not specified for PutAlias"
  end
  local uri = "/" .. self.index .. "/_alias/" .. self.name
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of PutAlias class
-------------------------------------------------------------------------------
function PutAlias:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return PutAlias
