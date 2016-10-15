-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local IndicesEndpoint = require "elasticsearch.endpoints.Indices.IndicesEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Delete = IndicesEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
Delete.allowedParams = {
  ["timeout"] = true,
  ["master_timeout"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function Delete:getMethod()
  return "DELETE"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function Delete:getUri()
  local uri = ""
  if self.index == nil then
    return nil, "index not specified for Delete"
  else
    uri = "/" .. self.index
  end
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of Delete class
-------------------------------------------------------------------------------
function Delete:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Delete
