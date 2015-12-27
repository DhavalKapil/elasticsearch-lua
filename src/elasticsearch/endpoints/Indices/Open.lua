-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "elasticsearch.endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Open = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
Open.allowedParams = {
  "timeout",
  "master_timeout",
  "ignore_unavailable",
  "allow_no_indices",
  "expand_wildcards"
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function Open:getMethod()
  return "POST"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function Open:getUri()
  if self.index == nil then
    return nil, "index not specified for Open"
  else
    return "/" .. self.index .. "/_open"
  end
end

-------------------------------------------------------------------------------
-- Returns an instance of Open class
-------------------------------------------------------------------------------
function Open:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Open
