-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local IndicesEndpoint = require "elasticsearch.endpoints.Indices.IndicesEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Close = IndicesEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
Close.allowedParams = {
  ["timeout"] = true,
  ["master_timeout"] = true,
  ["ignore_unavailable"] = true,
  ["allow_no_indices"] = true,
  ["expand_wildcards"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function Close:getMethod()
  return "POST"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function Close:getUri()
  if self.index == nil then
    return nil, "index not specified for Close"
  else
    return "/" .. self.index .. "/_close"
  end
end

-------------------------------------------------------------------------------
-- Returns an instance of Close class
-------------------------------------------------------------------------------
function Close:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Close
